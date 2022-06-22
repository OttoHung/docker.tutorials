import { Request, Response } from "express"
import { ReasonPhrases, StatusCodes } from "http-status-codes"

export class Endpoint {

    greeting(request: Request, response: Response) {
        response.send("Hello, Kitty!!!")
    }

    helthCheck(request: Request, response: Response) {
        response.status(StatusCodes.OK)
                .send(ReasonPhrases.OK)
    }
}