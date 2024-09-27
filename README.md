# Proyecto Rails

Se quiere una nueva funcionalidad mediante la cual, el administrador de la misma pueda crear exámenes para ser completados por los usuarios de la plataforma ya existentes.

Estos exámenes constan de varias preguntas y dichas preguntas pueden ser de diferentes tipos, concretamente nos comunican que les hacen falta 3 tipos: 

- Preguntas de texto libre
- Preguntas de selección múltiple (varias respuestas correctas)
- Preguntas de selección única (una respuesta correcta).

Además, las preguntas se podrán marcar como preguntas puntuables o no y en función de si se marca esta opción, el manager podrá definir cuántos puntos vale dicha pregunta.

Además, estos exámenes solo podrán ser completados por los usuarios en las fechas establecidas por el manager.

Las respuestas de los usuarios quedarán almacenadas de manera que el manager podrá ver para cada usuario los exámenes completados, nota obtenida y otras estadísticas.

Necesitamos que se pinte un modelo de datos que nos permita desarrollar esta funcionalidad, también los modelos de Rails y las relaciones que crees que son necesarias para cumplir todos los requerimientos y posibles evolutivos (relaciones entre modelos y validaciones).

En caso de necesitar lógica de código para resolver algún requisito sin definir a nivel de modelo de datos, por favor, describe la solución adjunto al diagrama y razona el por qué.

En lo que se refiere al tiempo, no hay límite para entregarla. No obstante, cuanto antes la tengamos, mucho mejor.

# Modelos 

![modelo](https://github.com/user-attachments/assets/ed56c493-ef42-4bf5-9a68-4268fd85574e)

1. Gestión de Usuarios y Roles:
   - User: Almacena la información básica de todos los usuarios.
   - Role y UserRole: Permiten asignar roles flexibles (admin, manager) a los usuarios, cumpliendo con el requisito de diferentes niveles de acceso.

2. Estructura de Exámenes:
   - Exam: Representa los exámenes con sus fechas de inicio y fin.
   - Question: Almacena las preguntas de diferentes tipos (texto libre, selección múltiple, selección única) y sus puntos.
   - Answer: Guarda las opciones de respuesta para preguntas de selección.

3. Realización de Exámenes:
   - UserExam: Registra cuando un usuario toma un examen, incluyendo la puntuación total.
   - UserAnswer: Almacena las respuestas específicas de cada usuario a cada pregunta.

4. Características Clave:
   - La relación entre Exam y Question permite tener múltiples preguntas por examen.
   - Question tiene un campo 'question_type' para diferenciar entre tipos de preguntas.
   - Answer se usa para preguntas de selección, mientras que las respuestas de texto libre se guardan directamente en UserAnswer.
   - UserExam facilita el cálculo y almacenamiento de la puntuación total.

Este modelo permite:
- Crear y gestionar exámenes con diferentes tipos de preguntas.
- Asignar roles y permisos a los usuarios.
- Registrar las respuestas de los usuarios y calcular puntuaciones.
- Proporcionar flexibilidad para futuras expansiones (como agregar límites de intentos.

# Vistas
## Home
![Screenshot 2024-09-19 161352](https://github.com/user-attachments/assets/c74d2b2c-af9c-4078-873e-785def8aaa47)
## Exam
### Index
![Screenshot 2024-09-19 161653](https://github.com/user-attachments/assets/95fe6a80-05d5-44a8-af1a-4b06f30a449e)
### Create
![Screenshot 2024-09-19 161719](https://github.com/user-attachments/assets/b0af4158-1e85-4d00-ad91-dc1c392dfe01)
### Show
![Screenshot 2024-09-19 161701](https://github.com/user-attachments/assets/2dd59c8e-e83c-4779-9168-68803bf8da0d)
### Assign
![Screenshot 2024-09-19 161732](https://github.com/user-attachments/assets/15f4ac90-340b-470b-b5b1-774c74b56173)

## Exam Attempt
![Screenshot 2024-09-19 161742](https://github.com/user-attachments/assets/72d3c576-db95-473b-9138-23274e2b86cb)

## Exam Results
![Screenshot 2024-09-19 161751](https://github.com/user-attachments/assets/ab990956-8ec0-42f7-bf8a-d2976aefcd66)

# Requisitos del sistema

Para ejecutar tu aplicación Rails con las gemas especificadas, necesitarás instalar varios componentes en tu sistema.

1. RVM (Ruby Version Manager):
   - Propósito: Gestionar múltiples versiones de Ruby en tu sistema.
   - Instalación: 
     ```
     gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
     \curl -sSL https://get.rvm.io | bash -s stable
     ```
   - Después de la instalación, instala la versión de Ruby que necesitas:
     ```
     rvm install 3.2.2 # O la versión que estés usando
     ```

2. NVM (Node Version Manager):
   - Propósito: Gestionar múltiples versiones de Node.js.
   - Instalación:
     ```
     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
     ```
   - Después, instala la versión de Node.js que necesitas:
     ```
     nvm install 20 # O la versión que prefieras
     ```

3. Yarn:
   - Propósito: Gestor de paquetes para JavaScript.
   - Instalación (después de instalar Node.js):
     ```
     npm install -g yarn
     ```

4. PostgreSQL:
   - Propósito: Sistema de gestión de bases de datos relacional.
   - Instalación (en Ubuntu/Debian):
     ```
     sudo apt-get update
     sudo apt-get install postgresql postgresql-contrib libpq-dev
     ```
   - En macOS con Homebrew:
     ```
     brew install postgresql
     ```

5. Git:
   - Propósito: Sistema de control de versiones.
   - Instalación (en Ubuntu/Debian):
     ```
     sudo apt-get install git
     ```
   - En macOS con Homebrew:
     ```
     brew install git
     ```

6. Bundler:
   - Propósito: Gestor de dependencias para Ruby.
   - Instalación (después de instalar Ruby):
     ```
     gem install bundler
     ```

7. Rails:
   - Propósito: Framework web.
   - Instalación (después de instalar Ruby):
     ```
     gem install rails -v 7.2.1
     ```

Pasos adicionales:

1. Configurar PostgreSQL:
   - Crear un usuario de base de datos para tu aplicación:
     ```
     sudo -u postgres createuser -s tuNombreDeUsuario
     ```

2. Ejecutar migraciones:
   - Dentro de la carpeta del proyecto ejecutar lo siguiente:
     ```
     rails db:create db:migrate db:seed
     ```
3.Iniciar sistema:
    ```
    ./dev/bin
    ```

- Los comandos pueden variar dependiendo de tu sistema operativo. He proporcionado ejemplos para sistemas basados en Ubuntu y macOS, que son comunes en el desarrollo de Rails.
