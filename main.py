from selenium_recaptcha_solver import RecaptchaSolver
from selenium import webdriver
from selenium.webdriver.edge.service import Service
from webdriver_manager.microsoft import EdgeChromiumDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from os import getenv


options = webdriver.EdgeOptions()
# options.add_argument('--headless')  # Run in headless mode
options.add_argument('--disable-gpu')  # Disable GPU acceleration
options.add_argument('--user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"')

# Initialize Edge WebDriver
driver = webdriver.Edge(service=Service(EdgeChromiumDriverManager().install()), options=options)

solver = RecaptchaSolver(driver=driver)

# Navigate to the URL
driver.get('https://agendamentos.mne.gov.pt/en/login')

# Wait for the page to load completely
WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "body")))

# Find and click the "Authentication via credentials" <div> element
auth_button = driver.find_element(By.XPATH, '//div[contains(text(), "Authentication via credentials")]')
auth_button.click()

# Wait for the login form (username and password fields) to appear
WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.NAME, "username")))  # Adjust the ID if needed

# Find the username and password input fields
username_field = driver.find_element(By.NAME, "username")  # Adjust if needed
password_field = driver.find_element(By.NAME, "password")  # Adjust if needed

# Enter your login credentials (replace with actual credentials)
username_field.send_keys(getenv('avidan_email'))
password_field.send_keys(getenv('avidan_pass'))

recaptcha_iframe = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.XPATH, '//iframe[@title="reCAPTCHA"]'))
)

solver.click_recaptcha_v2(iframe=recaptcha_iframe)

# Optionally, if CAPTCHA is solved, submit the form (or click login button)
login_button = driver.find_element(By.XPATH, "//button[@type='submit']")  # Adjust if needed
login_button.click()

# Wait until the page has loaded after the form submission
WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "body")))

# Print the page source after successful login
print(driver.page_source)

# Close the browser
driver.quit()