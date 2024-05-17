FROM ubuntu:latest

# Install necessary tools
RUN apt-get update && apt-get install -y curl unzip postgresql-client cron

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Copy the script and the crontab file to the container
COPY ./entrypoint.sh /entrypoint.sh
COPY ./crontab /etc/cron.d/crontab

# Give execution rights on the cron job and the script
RUN chmod 0644 /etc/cron.d/crontab
RUN chmod +x /entrypoint.sh

# Apply cron job
RUN crontab /etc/cron.d/crontab

CMD ["tail", "-f", "/dev/null"]