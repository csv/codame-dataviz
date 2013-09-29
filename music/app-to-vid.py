from selenium import webdriver
from datetime import datetime, timedelta
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import NoSuchFrameException
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import StaleElementReferenceException
from selenium.common.exceptions import TimeoutException
import time

def wait_cb():
    """Return a callback that checks whether a link in a class is available."""
    def callback(browser):
        try:
            b.find_element_by_id("is-available")
        except NoSuchElementException:
            return False
        else:
            return True
    return callback

b = webdriver.Chrome()
b.set_window_size(1280, 800)

base_url = "http://localhost:8000/#"
min_date = datetime(year=2005, month=01, day=01)
max_date =  datetime(year=2009, month=12, day=31)
date_range = [(min_date + timedelta(days=d)).strftime('%Y-%m-%d') for d in range(0 , (max_date - min_date).days + 1)]


for i, d in enumerate(date_range):
  url = base_url + d
  file_name = 'frames/frame-%04d.png' % i
  b.get(url)
  WebDriverWait(b, timeout=100).until(wait_cb())
  time.sleep(2)
  print 'saving %s from %s' % (file_name, url)
  b.get_screenshot_as_file(file_name)

