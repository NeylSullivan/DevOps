"""
Simple `README.md` generator. Scan and parse `*.bat` and `*.py` files, get first comment in file and generate Markdown text.
Text will be inserted between `<!-- AUTO_GENERATED_CONTENT_START -->` and `<!-- AUTO_GENERATED_CONTENT_END -->` comments
or will be appended to the end of existing (or new) `README.md` file.

For `*.bat` get header comment block (started with `::`)

For `*.py` get module docstring value.

CLI options:
-  `--dir DIRECTORY`  Override root scan dir (type: str, default: directory one level up)
-  `--toc ENABLED`    Generate table of contents (type: int, default: 1)
"""
import os
import fnmatch
import argparse

ROOT_SCAN_DIR = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))
GENERATE_TOC = True
DIRS_TO_SKIP = ['.idea', '.vs', '.git', 'venv']

TAG_AUTO_GENERATED_CONTENT_START = '<!-- AUTO_GENERATED_CONTENT_START -->'
TAG_AUTO_GENERATED_CONTENT_END = '<!-- AUTO_GENERATED_CONTENT_END -->'


class ScriptItem:
    def __init__(self):
        self.file_name = ''
        self.full_file_path = ''
        self.relative_file_path = ''  # relative to ROOT_SCAN_DIR
        self.content = ''

    def __repr__(self):
        return f'ScriptItem "{self.file_name}"'

    @staticmethod
    def try_construct(path: str):
        file_name = os.path.basename(path)
        for key in TYPES_TO_PARSE.keys():
            if fnmatch.fnmatch(file_name, key):
                content = TYPES_TO_PARSE[key](path)
                if content is not None:
                    item = ScriptItem()
                    item.file_name = file_name
                    item.full_file_path = path
                    item.relative_file_path = os.path.relpath(path, start=ROOT_SCAN_DIR)
                    item.content = content
                    return item
        return None


class DirItem:
    def __init__(self):
        self.depth = 0
        self.title = ''
        self.sub_items = []

    def __repr__(self):
        return f'DirItem "{self.title}" {self.sub_items}'

    @staticmethod
    def try_construct(path: str):
        dir_name = os.path.basename(path)
        if dir_name in DIRS_TO_SKIP:
            return None
        dir_items = DirItem.scan(path)
        if len(dir_items) > 0:
            dir_item = DirItem()
            dir_item.title = dir_name
            dir_item.sub_items = dir_items
            return dir_item

        return None

    @staticmethod
    def scan(path: str) -> []:
        sub_dirs = []
        files = []
        for item_name in os.listdir(path):
            full_path = os.path.realpath(os.path.join(path, item_name))

            if os.path.isdir(full_path):
                dir_item = DirItem.try_construct(full_path)
                if dir_item:
                    sub_dirs.append(dir_item)

            elif os.path.isfile(full_path):
                script_item = ScriptItem.try_construct(full_path)
                if script_item:
                    files.append(script_item)

        dir_content = []
        dir_content.extend(sub_dirs)
        dir_content.extend(files)

        return dir_content


def parse_py(path) -> str or None:
    print(f'Parsing: {path}')
    docstring = None
    try:
        import ast
        with open(path) as fd:
            file_contents = fd.read()
        module = ast.parse(file_contents)
        docstring = ast.get_docstring(module)
    finally:
        return docstring if docstring != '' else None


def parse_bat(path) -> str or None:
    print(f'Parsing: {path}')
    with open(path) as f:
        file_content = f.readlines()

    parsed = ''

    for line in file_content:
        line = line.lstrip()
        if line.startswith('::'):
            line = line.lstrip(line[0])
            line = line.removeprefix(' ')  # remove only one space character, other can be used for Markdown lists
            parsed += line
        else:
            break

    return parsed if parsed != '' else None


TYPES_TO_PARSE = {
    '*.bat': parse_bat,
    '*.py': parse_py
}


def generate_markdown_table_of_contents(dir_content, depth=0):
    table_of_contents = ''

    if depth == 0:
        table_of_contents = '## Table of Contents\n'

    for item in dir_content:
        if isinstance(item, DirItem):
            table_of_contents += f'{"  " * depth}- {item.title}\n'
            table_of_contents += generate_markdown_table_of_contents(item.sub_items, depth + 1)

        elif isinstance(item, ScriptItem):
            anchor = f'{item.relative_file_path}'.lower()
            anchor = anchor.replace('.', '').replace('_', '').replace('\\', '').replace(' ', '-')
            table_of_contents += f'{"  " * depth}- [{item.file_name}](#{anchor})\n'

    if depth == 0:
        table_of_contents += '---\n'

    return table_of_contents


def generate_markdown(dir_content):
    markdown = ''

    for item in dir_content:
        if isinstance(item, DirItem):
            markdown += generate_markdown(item.sub_items)

        elif isinstance(item, ScriptItem):
            markdown += f'### {item.relative_file_path}\n'
            markdown += item.content
            markdown += '\n---\n'

    return markdown


def sanitize_file_content(file_content):
    """
    Try to sanitize file_content, removing all lines between start/end tags
    """
    lines = file_content.splitlines(keepends=True)
    start_tag_line_idx = -1
    end_tag_line_idx = -1
    for idx in range(len(lines)):
        if start_tag_line_idx == -1 and lines[idx].startswith(TAG_AUTO_GENERATED_CONTENT_START):
            start_tag_line_idx = idx
            continue

        # Don't stop, check to the end
        if lines[idx].startswith(TAG_AUTO_GENERATED_CONTENT_END):
            end_tag_line_idx = idx

    if start_tag_line_idx != -1 and end_tag_line_idx != -1 and start_tag_line_idx < end_tag_line_idx:
        for idx in range(start_tag_line_idx + 1, end_tag_line_idx):
            lines[idx] = ''
        file_content = ''.join(lines)

    return file_content


def main():
    assert os.path.exists(ROOT_SCAN_DIR), f'ROOT_SCAN_DIR "{ROOT_SCAN_DIR}" not exist'
    assert os.path.isdir(ROOT_SCAN_DIR), f'ROOT_SCAN_DIR "{ROOT_SCAN_DIR}" not a directory'
    print(f'ROOT_SCAN_DIR: {ROOT_SCAN_DIR}')
    print(f'GENERATE_TOC={GENERATE_TOC}')

    dir_content = DirItem.scan(ROOT_SCAN_DIR)

    print('\nParsed content:\n')
    for item in dir_content:
        print(item)
    print()

    markdown_string = ''
    markdown_string += f'{TAG_AUTO_GENERATED_CONTENT_START}\n'

    if GENERATE_TOC:
        markdown_string += generate_markdown_table_of_contents(dir_content)

    markdown_string += generate_markdown(dir_content)
    markdown_string += f'{TAG_AUTO_GENERATED_CONTENT_END}'

    readme_file_path = os.path.join(ROOT_SCAN_DIR, 'README.md')
    print(f'Generating file {readme_file_path}', end=' ')

    file_content = ''
    if os.path.exists(readme_file_path):
        print('(Exist)')
        file = open(readme_file_path, 'r')
        file_content = file.read()
        file.close()

    file_content = sanitize_file_content(file_content)

    start_tag_idx = file_content.find(TAG_AUTO_GENERATED_CONTENT_START)
    if start_tag_idx != -1:
        end_tag_idx = file_content.find(TAG_AUTO_GENERATED_CONTENT_END, start_tag_idx)
        if end_tag_idx != -1:
            print('Start and end tags found, content will be inserted inbetween')
            file_content = file_content[:start_tag_idx] + markdown_string + file_content[end_tag_idx + len(TAG_AUTO_GENERATED_CONTENT_END):]
        else:
            print('Only start tag found, it will be replaced with generated content')
            file_content = file_content.replace(TAG_AUTO_GENERATED_CONTENT_START, markdown_string)
    else:
        print('No tags found, content will be appended to the end')
        if len(file_content) > 0:
            file_content += '\n'
        file_content += markdown_string

    file = open(readme_file_path, 'w+')
    file.write(file_content)  # directly write to file
    file.close()
    print('\nFinished\n')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--dir', metavar='DIRECTORY', type=str, default=ROOT_SCAN_DIR, help="Override root scan dir (type: %(type)s, default: %(default)s)")
    parser.add_argument("--toc", metavar='ENABLED', type=int, default=1, help="Generate table of contents (type: %(type)s, default: %(default)s)")
    args = parser.parse_args()

    if args.dir and args.dir != ROOT_SCAN_DIR:
        print(f'Overriding root scan dir to: {args.dir}')
        ROOT_SCAN_DIR = args.dir

    print(args.toc)
    GENERATE_TOC = args.toc

    main()
