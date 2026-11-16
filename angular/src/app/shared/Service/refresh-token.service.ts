import {throwError as observableThrowError, Observable, BehaviorSubject} from 'rxjs';

import {take, filter, catchError, switchMap, finalize} from 'rxjs/operators';
import {Injectable} from '@angular/core';
import {
  HttpRequest, HttpHandler, HttpSentEvent, HttpHeaderResponse, HttpProgressEvent,
  HttpResponse, HttpUserEvent, HttpErrorResponse
} from '@angular/common/http';
import {RequestService} from "./request.service";
import {Router} from '@angular/router';

@Injectable({
  providedIn: 'root'
})
export class RefreshTokenService {

  private isRefreshingToken = false;
  private tokenSubject: BehaviorSubject<string> = new BehaviorSubject<string>(null);

  constructor(public authService: RequestService, public router: Router) {}


  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpSentEvent | HttpHeaderResponse |
    HttpProgressEvent | HttpResponse<any> | HttpUserEvent<any>> {
    return next.handle(request).pipe(
      catchError(error => {

        if (error instanceof HttpErrorResponse) {
          if (request.url.includes('refresh') ||
            request.url.includes('login')  ) {
            // We do another check to see if refresh token failed
            // In this case we want to logout user and to redirect it to login page
            if (request.url.includes('refresh')) {
              return this.logoutUser();
            }
            return observableThrowError(error);
          }
          switch ((<HttpErrorResponse>error).status) {
            case 400:
              return this.handle400Error(error);
            case 401:
              return this.handle401Error(request, next);
            default:
              return observableThrowError(error);
          }
        } else {
          return observableThrowError(error);
        }
      }));
  }

  handle400Error(error) {
    if (error && error.status === 400 && error.error && error.error.error === 'invalid_grant') {
      // If we get a 400 and the error message is 'invalid_grant', the token is no longer valid so logout.
      return this.logoutUser();
    }

    return observableThrowError(error);
  }

  handle401Error(request: HttpRequest<any>, next: HttpHandler) {
    if (!this.isRefreshingToken) {
      this.isRefreshingToken = true;

      // Reset here so that the following requests wait until the token
      // comes back from the refreshToken call.
      this.tokenSubject.next(null);

      const authService = this.authService;

      return authService.refreshToken().pipe(
        switchMap((newToken: string) => {
          if (newToken && newToken !== 'error') {
            this.tokenSubject.next(newToken);
            return next.handle(this.getNewRequest(request, newToken));
          }

          // If we don't get a new token, we are in trouble so logout.
          return this.logoutUser();
        }),
        catchError(error => {
          // If there is an exception calling 'refreshToken', bad news so logout.
          return this.logoutUser();
        }),
        finalize(() => {
          this.isRefreshingToken = false;
        }), );
    } else {
      return this.tokenSubject.pipe(
        filter(token => token != null),
        take(1),
        switchMap(token => {
          return next.handle(this.getNewRequest(request, token));
        }), );
    }
  }


  getNewRequest(request: HttpRequest<any>, token: string): HttpRequest<any> {
    const newAccessToken = token;

    // If access token is null this means that user is not logged in
    // And we return the original request
    if (!newAccessToken) {
      return request;
    }

    // We clone the request, because the original request is immutable
    return request.clone({
      setHeaders: {
        Authorization: 'Bearer ' + newAccessToken
      }
    });
  }

  logoutUser() {
    window.localStorage.clear();
    this.router.navigate([`/administrator/${this.authService.activeCountryCode}/login`]);
    return observableThrowError('');
  }
}
