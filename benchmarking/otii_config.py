import time
import paramiko
from otii_tcp_client import otii_client

def create_otii_app():
    client = otii_client.OtiiClient().connect()
    return client

def configure_multimeter(otii_app):
    # Get device
    devices = otii_app.get_devices()
    if len(devices) == 0:
        raise Exception("No Arc or Ace connected!")
    device = devices[0]

    # Define channels
    device.enable_channel('mp', True)
    device.enable_channel('mc', True)
    device.enable_channel('mv', True)

    # Setup device
    device.set_main_voltage(5.0)
    device.set_exp_voltage(4.9)
    device.set_max_current(2.5)

    project = otii_app.get_active_project()
    return project, device

def run_ssh_command(num, com):
    # Connection details
    hostname = "scv"
    username = "oskar"
    password = "oskar"
    command = com + str(num)
    app = create_otii_app()
    proj, dev = configure_multimeter(app)
    
    try:
        # Create an SSH client
        ssh_client = paramiko.SSHClient()
        ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        # Connect to the SSH server
        print(f"Connecting to {username}@{hostname}...")
        ssh_client.connect(hostname, username=username, password=password)
        print("Connection established.")

        # Execute the command
        proj.start_recording()
        print(f"Running command: {command}")
        stdin, stdout, stderr = ssh_client.exec_command(command)

        # Wait for the command to complete and fetch outputs
        exit_status = stdout.channel.recv_exit_status()
        print(f"Command completed with exit status: {exit_status}")
        proj.stop_recording()

        # Print the standard output and error
        print("Standard Output:")
        for line in stdout.read().decode().splitlines():
            print(line)

        print("Standard Error:")
        for line in stderr.read().decode().splitlines():
            print(line)
            
    except Exception as e:
        print(f"An error occurred: {e}")
    
    finally:
        # Close the connection
        ssh_client.close()
        print("Connection closed.")

# Run benchmarks 10 times on each Python version to be tested
for j in range(3):
    if (j == 0):
        com = "sh pypower.sh python3.9 /usr/bin/python3.9 "
    if (j == 1):
        com = "sh pypower.sh python3.12 /usr/local/bin/python3.12 "
    if (j == 2):
        com = "sh pypower.sh python3.13 /usr/local/bin/python3.13 "
    for i in range(10):
        run_ssh_command(i + 1, com)
        if (i != 9):
            time.sleep(15)

