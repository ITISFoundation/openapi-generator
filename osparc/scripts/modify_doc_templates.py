from pathlib import Path
from argparse import ArgumentParser
import logging


def modify_single_doc_file(file: Path):
    logging.info(f"formatting {file}")
    if not file.is_file():
        raise RuntimeError(f"{file} is not a file")
    txt = file.read_text()
    txt = txt.replace('YOUR_USERNAME','YOUR_API_KEY_HERE')
    txt = txt.replace('YOUR_PASSWORD','YOUR_API_SECRET_HERE')
    txt = txt.replace('{{{basePath}}}','https://api.osparc.io')
    txt = txt.replace('{{basePath}}','https://api.osparc.io')
    if not txt.endswith("\n"):
        txt += "\n"

    lines = txt.splitlines()
    for idx, line in enumerate(lines):
        if line.startswith("```python"):
            lines[idx] = "\n" + line
    txt = "\n".join(lines)
    
    file.write_text(txt)
    

if __name__ == '__main__':
    parser = ArgumentParser('Small tool for making openapi generator doc templates comply with osparc')
    parser.add_argument('path', help='Path to folder or file to be formatted. If "path" is a folder then it is recursed and all files containing "doc" in their name are modified')
    parser.add_argument( '-doc_match', default='doc', help='Files containing this string in their name are considered documentation files' )
    parser.add_argument( '-loglevel', default='warning', help='Provide logging level. Example --loglevel debug, default=warning' )
    args = parser.parse_args()

    if args.loglevel.upper() not in dir(logging):
        raise ValueError(f"Incorrect -loglevel: {args.loglevel}")
    path = Path(args.path)
    logging.basicConfig( level=args.loglevel.upper() )
    if path.is_dir():
        for file in path.glob('**/*'):
            if file.is_file() and args.doc_match in file.name:
                modify_single_doc_file(file)
    else:
        modify_single_doc_file(path)
    
