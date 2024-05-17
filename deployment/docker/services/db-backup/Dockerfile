FROM ubuntu:latest

# Install necessary tools
RUN apt-get update && apt-get install -y python3 python3-pip postgresql-client cron

# Install AWS CLI
RUN pip3 install awscli

# Copy the script and the crontab file to the container
COPY ./entrypoint.sh /entrypoint.sh
COPY ./crontab /etc/cron.d/crontab

# Give execution rights on the cron job and the script
RUN chmod 0644 /etc/cron.d/crontab
RUN chmod +x /entrypoint.sh

# Apply cron job
RUN crontab /etc/cron.d/crontab