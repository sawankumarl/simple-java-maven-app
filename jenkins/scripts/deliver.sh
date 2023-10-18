#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

echo 'The following complex command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
NAME=`mvn help:evaluate -Dexpression=project.name | grep "^[^\[]"`
set +x

echo 'The following complex command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
VERSION=`mvn help:evaluate -Dexpression=project.version | grep "^[^\[]"`
set +x

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
# set -x
# java -jar target/${NAME}-${VERSION}.jar

# Construct the JAR file name using NAME and VERSION variables
JAR_FILE="target/${NAME}-${VERSION}.jar"

# Check if the "target" directory exists and if the JAR file exists before running it
if [ -d "target" ] && [ -f "$JAR_FILE" ]; then
  set -x
  java -jar "$JAR_FILE"
else
  if [ ! -d "target" ]; then
    echo "Error: The 'target' directory does not exist."
  fi

  if [ ! -f "$JAR_FILE" ]; then
    echo "Error: The JAR file $JAR_FILE does not exist."
  fi
fi
