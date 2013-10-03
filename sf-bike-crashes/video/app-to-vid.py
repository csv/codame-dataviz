from selenium import webdriver
from datetime import datetime, timedelta
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import NoSuchFrameException
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import StaleElementReferenceException
from selenium.common.exceptions import TimeoutException
import time, os
from thready import threaded

def wait_cb():
    """Return a callback that checks whether a link in a class is available."""
    def callback(browser):
        try:
            b.find_element_by_id("is-available")
        except NoSuchElementException:
            return Falseew
        else:
            return True
    return callback

def grab_screenshot(indexed_date):
    i, date = indexed_date
    url = base_url + date
    file_name = 'frames/frame-%04d.png' % i
    b.get(url)
    time.sleep(0.5)
    print 'saving %s from %s' % (file_name, url)
    b.get_screenshot_as_file(file_name)
    time.sleep(0.5)


b = webdriver.Firefox()
b.set_window_size(1280, 800)

base_url = "http://localhost:8000/#"
min_date = datetime(year=2005, month=01, day=01)
max_date =  datetime(year=2009, month=12, day=31)
date_range = [(min_date + timedelta(days=d)).strftime('%Y-%m-%d') for d in range(0 , (max_date - min_date).days + 1)]
indexed_date_range = [(i,d) for i, d in enumerate(date_range)]

if 'frames' not in os.listdir('.'):
    os.mkdir('frames')

if __name__ == '__main__':
    for indexed_date in indexed_date_range:
        grab_screenshot(indexed_date)
