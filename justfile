fmt:
    find . -type f -name '*.just' -exec just --unstable --fmt -f {} \;