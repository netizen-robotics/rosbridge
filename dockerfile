FROM public.ecr.aws/y8l1o1z1/ros2-jazzy:latest

USER root

# Install library for Orbbec sdk 
RUN apt-get update
RUN apt-get install ros-${ROS2_DISTRO}-rosbridge-suite -y

# Using robot workspace
WORKDIR /home/user/robot_ws/src

# Clone Web Video Server
RUN git clone -b ros2 https://github.com/RobotWebTools/web_video_server.git

WORKDIR /home/user/robot_ws
RUN rosdep install --from-paths src --ignore-src -r -y
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && colcon build

# Setup entrypoint
COPY --chown=user:netizen_robotics ./script/entrypoint.sh  /home/user/entrypoint.sh
RUN chmod +x /home/user/entrypoint.sh

# Switch to user
USER user
WORKDIR /home/user
ENTRYPOINT ["/home/user/entrypoint.sh"]