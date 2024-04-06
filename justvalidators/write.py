from functools import partial
import argparse
import json
import os
import subprocess

plutus_dir = {"primary": os.environ.get(
    'PLUTUS_SCRIPTS_PATH'), "secondary": '.plutus'}
addr_dir = {"primary": os.environ.get('ADDR_PATH'), "secondary": '.addr'}


def read_json_file(file_path):
    try:
        with open(file_path, 'r') as file:
            data = json.load(file)
            return data
    except FileNotFoundError:
        print(f"Error: File not found at {file_path}")
    except json.JSONDecodeError:
        print(f"Error: Unable to decode JSON in file at {file_path}")


def mk_output(version, validator):
    return {
        'type': version,
        'description': validator.get('title').split('.')[1],
        'cborHex': validator.get('compiledCode')
    }


def split_title(validator):
    return validator.get('title').split('.')


def convert_blueprint(validator):
    (m, v) = split_title(validator)
    cmd = f'aiken blueprint convert -m {m} -v {v} .'
    try:
        result = subprocess.run(cmd, shell=True, check=True,
                                capture_output=True, text=True)
        json_output = json.loads(result.stdout)

        if 'description' in json_output:
            json_output['description'] = v

        return json_output
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")
        return None


def mk_filepath(target_dir, extension, validator, suffix=None):
    base_name = validator.get('description').replace('_', '-')
    file_name = f'{base_name}-{suffix}.{extension}' if suffix else f'{base_name}.{extension}'
    file_path = f'{target_dir["primary"]}/{file_name}' if target_dir["primary"] else f'{target_dir["secondary"]}/{file_name}'

    return file_path


mk_fp_plutus = partial(mk_filepath, plutus_dir, 'plutus')

mk_fp_addr = partial(mk_filepath, addr_dir, 'addr')


def write_file(write_func, file_path):
    if os.path.exists(file_path):
        overwrite = input(
            f"File '{file_path}' already exists. Overwrite? [y/N]: ").lower()
        if overwrite != 'y':
            return
    write_func()


def write_plutus(validator, suffix=None):
    file_path = mk_fp_plutus(validator, suffix)

    def wf_plutus():
        with open(file_path, 'w', encoding='utf-8') as target_file:
            json.dump(validator, target_file, indent=4)
            print(f"Wrote validator to '{file_path}'")

    write_file(wf_plutus, file_path)


def write_addr(validator, suffix=None):
    plutus_fp = mk_fp_plutus(validator, suffix)
    addr_fp = mk_fp_addr(validator, suffix)

    def wf_addr():
        if not os.path.exists(plutus_fp):
            print(f"Error: no plutus script found at '{plutus_fp}'.")
            return
        cmd = f'cardano-cli address build \
    --payment-script-file {plutus_fp} \
    --out-file {addr_fp}'
        try:
            subprocess.run(cmd, shell=True, check=True,
                           capture_output=True, text=True)
            print(f"Wrote script address to '{addr_fp}'")
        except subprocess.CalledProcessError as e:
            print(f"Error: {e}")

    write_file(wf_addr, addr_fp)


def write(suffix=None):
    parser = argparse.ArgumentParser(
        description="A script with an optional argument.")
    parser.add_argument('--validator', '-v', type=str,
                        help='Specify a validator name.')

    args = parser.parse_args()

    print("\nWriting scripts and addresses...\n")
    plutus_json_path = 'plutus.json'
    plutus_json = read_json_file(plutus_json_path)

    if plutus_json:
        json_vals = plutus_json.get('validators')
        if args.validator:
            arg_val = next(
                filter(
                    lambda v: split_title(v)[1] == args.validator, json_vals),
                None)
            if arg_val:
                validators = [convert_blueprint(arg_val)]
            else:
                print(f"Error: '{args.validator}' not found in plutus.json!")
                exit(1)
        else:
            validators = [convert_blueprint(val)
                          for val in json_vals]
        for val in validators:
            write_plutus(val, suffix)
            write_addr(val, suffix)


write('ak')