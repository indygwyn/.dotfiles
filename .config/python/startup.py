import atexit

# stdlib
import csv
import datetime as dt
import hashlib
import json
import math
import os
import random
import re
import shelve
import subprocess
import sys
import tempfile
from collections import *
from functools import partial
from inspect import getmembers, ismethod, stack
from io import open
from itertools import *
from math import *
from pprint import pprint as pretty_print
from types import FunctionType
from uuid import uuid4
from unittest.mock import patch, Mock, MagicMock
from datetime import datetime, date, timedelta

import pip

# Set ipython prompt to ">>> " for easier copying
try:
    from IPython import get_ipython

    get_ipython().run_line_magic("doctest_mode", "")
    get_ipython().run_line_magic("load_ext", "ipython_autoimport")
except:
    pass

try:
    import asyncio

    # for easier pasting
    from typing import *
    from dataclasses import dataclass, field
except ImportError:
    pass

try:
    import pendulum
except ImportError:
    pass

try:
    import requests
except ImportError:
    pass

try:
    import readline

    readline.parse_and_bind("tab: complete")
except ImportError:
    pass

try:
    from rich import pretty

    pretty.install()
except ImportError:
    pass

from pathlib import Path

try:

    class PathLiteral:
        def __truediv__(self, other):
            try:
                return Path(other.format(**stack()[1][0].f_globals))
            except KeyError as e:
                raise NameError("name {e} is not defined".format(e=e))

        def __call__(self, string):
            return self / string

    p = PathLiteral()
except ImportError:
    pass

try:
    from IPython.core.interactiveshell import InteractiveShell

    InteractiveShell.ast_node_interactivity = "all"

except ImportError:
    pass

VENV = os.environ.get("VIRTUAL_ENV")
TEMP_DIR = Path(tempfile.gettempdir()) / "pythontemp"
try:
    os.makedirs(TEMP_DIR)
except Exception as e:
    pass


def now():
    return datetime.now()


def today():
    return date.today()


class Store(object):
    def __init__(self, filename):
        object.__setattr__(self, "DICT", shelve.DbfilenameShelf(filename))
        # cleaning the dict on the way out
        atexit.register(self._clean)

    def __getattribute__(self, name):
        if name not in ("DICT", "_clean"):
            try:
                return self.DICT[name]
            except:
                return None
        return object.__getattribute__(self, name)

    def __setattr__(self, name, value):
        if name in ("DICT", "_clean"):
            raise ValueError("'%s' is a reserved name for this store" % name)
        self.DICT[name] = value

    def _clean(self):
        self.DICT.sync()
        self.DICT.close()


python_version = "py%s" % sys.version_info.major
try:
    store = Store(os.path.join(TEMP_DIR, "store.%s.db") % python_version)
except:
    # This could be solved using diskcache but I never took the time
    # to do it.
    print("\n/!// A session using this store already exist.")


# Shorcurt to pip install packages without leaving the shell
def pip_install(*packages):
    """Install packages directly in the shell"""
    for name in packages:
        cmd = ["install", name]
        if not hasattr(sys, "real_prefix"):
            raise ValueError("Not in a virtualenv")
        pip.main(cmd)


def is_public_attribute(obj, name, methods=()):
    return not name.startswith("_") and name not in methods and hasattr(obj, name)


# if rich is not installed
def attributes(obj):
    members = getmembers(type(obj))
    methods = {name for name, val in members if callable(val)}
    is_allowed = partial(is_public_attribute, methods=methods)
    return {name: getattr(obj, name) for name in dir(obj) if is_allowed(obj, name)}


STDLIB_COLLECTIONS = (
    str,
    bytes,
    int,
    float,
    complex,
    memoryview,
    dict,
    tuple,
    set,
    bool,
    bytearray,
    frozenset,
    slice,
    deque,
    defaultdict,
    OrderedDict,
    Counter,
)

try:
    # rich a great pretty printer, but if it's not there,
    # I have a decent fallback
    from rich.pretty import print as pprint
except ImportError:

    def pprint(obj):
        if isinstance(obj, STDLIB_COLLECTIONS):
            pretty_print(obj)
        else:
            try:
                name = "class " + obj.__name__
            except AttributeError:
                name = obj.__class__.__name__ + "()"
            class_name = obj.__class__.__name__
            print(name + ":")
            attrs = attributes(obj)
            if not attrs:
                print("    <No attributes>")
            for name, val in attributes(obj).items():
                print("   ", name, "=", val)


# pp/obj is a shortcut to pprint(obj), it work as a postfix operator as
# well, which in the shell is handy
class Printer(float):
    def __call__(self, *args, **kwargs):
        pprint(*args, **kwargs)

    def __truediv__(self, other):
        pprint(other)

    def __rtruediv__(self, other):
        pprint(other)

    def __repr__(self):
        return repr(pprint)


pp = Printer()
pp.__doc__ = pprint.__doc__


# Same as the printer, but for turning something into a list with l/obj
class ToList(list):
    def __truediv__(self, other):
        return list(other)

    def __rtruediv__(self, other):
        return list(other)

    def __call__(self, *args, **kwargs):
        return list(*args, **kwargs)


l = ToList()

# Those alias means JSON is now valid Python syntax that you can copy/paste
null = None
true = True
false = False

# faker is a great library to generate fake data, so I have a shortcut for it
# If I want 10 fake emails, I can do fake.email(10)

try:
    import faker
except ImportError:
    pass
else:
    from faker.providers import internet, geo

    def get_faker(locale="en"):
        fake = faker.Faker(locale)
        fake.add_provider(internet)
        fake.add_provider(geo)
        return fake

    class Fake(object):
        factory = get_faker()

        @property
        def fr(self):
            self.factory = get_faker("fr_FR")
            return self

        @property
        def en(self):
            self.factory = get_faker()
            return self

        def __getattr__(self, name):
            faker_provider = self.factory.__getattr__(name)
            return lambda count=1: self.call_faker(faker_provider, count)

        def __dir__(self):
            attrs = [
                attr for factory in fake.factory._factories for attr in dir(factory)
            ]
            return ["fr", "en", *attrs]

        def call_faker(self, faker_provider, count=1):
            if count == 1:
                return faker_provider()
            else:
                return [faker_provider() for _ in range(count)]

    fake = Fake()
