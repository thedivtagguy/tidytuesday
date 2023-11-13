from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import os

# Initialize the Chrome Driver
driver = webdriver.Chrome()

# Set the desired resolution, e.g., 1920x1080
driver.set_window_size(1920, 1080)

# Open the local HTML file
file_path = 'file://' + os.path.join(os.getcwd(), 'credit.html')
driver.get(file_path)

# Take a screenshot and save it
driver.save_screenshot('high_res_screenshot.png')

# Close the browser
driver.quit()
