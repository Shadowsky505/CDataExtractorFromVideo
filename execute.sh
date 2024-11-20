apt update
apt install docker.io docker-compose -y

read -p "Ingresa tu API Key: " API_KEY

export API_KEY

docker-compose up --build -d

echo "El contenedor 'vosk-api-container' está corriendo en el puerto 8000."
