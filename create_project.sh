#!/bin/bash

# Verify a root dir provided
if [ -z "$1" ]; then
  echo "Use: $0 root_dir_name type1=name1 type2=name2 ..."
  echo "Projects type: react, vue, nestjs, express"
  exit 1
fi

# Asign the name to the root_dir in a variable
ROOT_DIR=$1
shift

# Create root dir
mkdir $ROOT_DIR

# go into root dir
cd $ROOT_DIR

# Función para crear un proyecto según el type especificado
create_project() {
  PROJECT_TYPE=$1
  PROJECT_NAME=$2
  
  # Create project folder
  mkdir $PROJECT_NAME

  # Navigate to the project folder
  cd $PROJECT_NAME

  # Init git repository
  git init

  # Create file .gitignore and add node_modules
  echo "/node_modules" > .gitignore

  # Create project according to the type specified
  case $PROJECT_TYPE in
    react)
      npx create-react-app .
      ;;
    vue)
      npm install -g @vue/cli
      vue create . --default
      ;;
    nestjs)
      npm install -g @nestjs/cli
      nest new .
      ;;
    express)
      npm init -y
      npm install express
      echo "const express = require('express');" > index.js
      echo "const app = express();" >> index.js
      echo "const port = 3000;" >> index.js
      echo "app.get('/', (req, res) => res.send('Hello World!'));" >> index.js
      echo "app.listen(port, () => console.log(\`Server running at http://localhost:\${port}/\`));" >> index.js
      sed -i '' 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"start": "node index.js"/' package.json
      ;;
    *)
      echo "Unrecognized project type. Valid types are: react, vue, nestjs, express."
      cd ..
      rm -rf $PROJECT_NAME
      return
      ;;
  esac

  # Install dependencies
  npm install

  # Go back to root dir
  cd ..

  # Final message
  echo "Project $PROJECT_NAME of type $PROJECT_TYPE created successfully."
}

# Create projects according to the parameters provided
for arg in "$@"; do
  type=$(echo $arg | cut -d'=' -f1)
  name=$(echo $arg | cut -d'=' -f2)
  create_project $type $name
done

echo "Projects created in directory $ROOT_DIR."
