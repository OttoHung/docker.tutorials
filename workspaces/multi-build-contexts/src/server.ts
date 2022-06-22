import { Endpoint } from "./endpoint"
import express from "express"

const DEFAULT_PORT = 5478

const endpoint = new Endpoint()
const port = DEFAULT_PORT
const app = express()

app.get("/", endpoint.greeting)
   .get("/health_check", endpoint.helthCheck)


const server = app.listen(port, () => {
    console.log(`Server starts and listens to ${port}`)
})

//This terminates the service when Control+C is pressed
process.on('SIGINT', () => {
    server.close(() => {
        console.log("Server is cancelled!!")
    })
})

//This terminates the service when `docker kill -s SIGTERM` is executed
process.on('SIGTERM', () => {
    server.close(() => {
        console.log("Server is terminated!!")
    })
})