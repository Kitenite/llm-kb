import re


def clean_text(text):
    # Replace newline characters and carriage returns with a space
    text = text.replace("\n", " ").replace("\r", " ")

    # Remove any extra whitespace (e.g., multiple spaces in a row)
    text = re.sub(" +", " ", text)

    # Remove leading and trailing whitespaces
    text = text.strip()

    return text
