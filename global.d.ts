/// <reference path="wwwroot/js/app.d.ts" />

declare global {

    interface Window {
        app: App;
    }

    // var app: App

    type Guid = string & { isGuid: true }

    interface IAccountLoginResponse {
        isAuthSuccessful: boolean
        errorMessage: string
        token: string
        refreshToken: string
    }

    interface IUserActionResult<T = void> {
        message: string
        ok: boolean
        data?: T
    }

}

export { }