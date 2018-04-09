import lxml.html as lx
import requests
from flask_restful import Resource

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0',
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
}

cache = {}


def load_rest_endpoint(core):
    location = '/rest/bus/times/<string:line_number>'

    class TimeTablesEndpoint(Resource):
        def __init__(self):
            self.core = core

        @staticmethod
        def get_line_url(line_number: str):
            url_base = 'https://www.busevi.com'
            home_html = requests.get(url_base).text
            root = lx.fromstring(home_html)
            line_url = None
            line_buttons = root.cssselect('.vc_btn3')
            for line_button in line_buttons:
                if line_button:
                    if line_button.text.lower() == line_number.lower():
                        line_url = f'{url_base}{line_button.attrib.get("href")}'
                        break
            return line_url

        @staticmethod
        def parse_time(element):
            row_list = []
            for row in element:
                text_list = []
                for column in row:
                    text_list.append(column.text.strip())
                row_list.append(text_list)
            return row_list

        @staticmethod
        def parse_title(heads: list, index: int):
            loop_index = 0
            line_title = None
            for head in heads:
                if loop_index == index:
                    line_title = head[0][0][0].text
                    break
                loop_index += 1
            return line_title

        @staticmethod
        def parse_slices(slices: list):
            slice_list = []
            for slice_piece in slices:
                slice_data = {}
                slice_hour = slice_piece[0]
                regular_minutes = slice_piece[1].split()
                saturday_minutes = slice_piece[2].split()
                sunday_minutes = slice_piece[3].split()
                slice_data.update(
                    {
                        'hour': slice_hour,
                        'reg': regular_minutes,
                        'sat': saturday_minutes,
                        'sun': sunday_minutes
                    }
                )
                slice_list.append(slice_data)
            return slice_list

        def get_time_table(self, page_url: str):
            time_html = requests.get(page_url, headers=headers).text
            root = lx.fromstring(time_html)
            table_elems = root.cssselect('.row-hover')
            time_indexes = [(1, 8), (3, 32)]
            loop_index = 0
            time_data = []
            line_title_heads = root.cssselect('.wpb_wrapper')
            for element in table_elems:
                for time_index, title_index in time_indexes:
                    if loop_index == time_index:
                        line_title = self.parse_title(line_title_heads, title_index)
                        time_slices = self.parse_time(element)
                        parsed_slices = self.parse_slices(time_slices)
                        slice_data = {'terminus': line_title, 'times': parsed_slices}
                        time_data.append(slice_data)
                loop_index += 1
            return time_data

        @staticmethod
        def parse_lines(html_str: str):
            root = lx.fromstring(html_str)
            line_items = root.cssselect('.asl_res_url')
            line_list = []
            for line_item in line_items:
                line_url = line_item.attrib.get('href')
                line_name = line_item.text.strip()
                line_data = {'name': line_name, 'url': line_url}
                line_list.append(line_data)
            return line_list

        @staticmethod
        def get_correct(lookup: int, itterable: list):
            result = None
            for itter in itterable:
                itter_name = itter.get('name')
                if itter_name.startswith(f'Linija {lookup}'):
                    result = itter
                    break
            return result

        def get(self, line_number: str):
            target_cache = cache.get(line_number)
            if target_cache:
                result = target_cache
            else:
                target_line = self.get_line_url(line_number)
                if target_line:
                    time_table_data = self.get_time_table(target_line)
                    cache.update({line_number: time_table_data})
                    result = time_table_data or {'error': 'Line data not found.'}
                else:
                    result = {'error': 'Line data not found.'}
            return result

    return TimeTablesEndpoint, location
