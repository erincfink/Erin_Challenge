import sys
import re

syntax = re.compile(r'(([0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4})|([0-9]{16}))')
limit_repeats = re.compile(r'(?!.*(\d)\1{3}.*).*')
starts_with = re.compile(r'^[4-6]')

def regex_check(card_num):
    if syntax.match(card_num):
        card_num = re.sub('-', '', card_num)
        return limit_repeats.match(card_num) and starts_with.match(card_num)

def main():
    card_reader = sys.stdin
    card_count = card_reader.readline()

    for i in card_reader.readlines():
        if regex_check(i):
            print('Valid')
        else:
            print('Invalid')


main()


# If there was a chance there would be more constraints, I would consider looping through the constraints
