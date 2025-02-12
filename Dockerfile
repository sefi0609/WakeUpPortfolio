FROM python:3.10-alpine

# Install dependencies
RUN apk update
RUN apk add --no-cache \
    chromium \
    chromium-chromedriver \
    xvfb

RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir selenium

WORKDIR /app
COPY wakeup_portfolio.py ./wakeup_portfolio.py

CMD ["python", "wakeup_portfolio.py"]
