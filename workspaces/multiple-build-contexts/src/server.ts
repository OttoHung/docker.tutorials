import { Endpoint } from "./endpoint"
import express from "express"

const DEFAULT_PORT = 5478

const endpoint = new Endpoint()
const port = DEFAULT_PORT
const app = express()

app.get("/", endpoint.greeting)
   .get("/health_check", endpoint.helthCheck)


app.listen(port, () => {
    console.log(`Server starts and listens to ${port}`)
})

