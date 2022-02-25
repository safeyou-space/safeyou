import {throwError as observableThrowError, Observable, BehaviorSubject} from 'rxjs';

import {take, filter, catchError, switchMap, finalize} from 'rxjs/operators';
import {Injectable} from '@angular/core';
import {
  HttpRequest, HttpHandler, HttpSentEvent, HttpHeaderResponse, HttpProgressEvent,
  HttpResponse, HttpUserEvent, HttpErrorResponse
} from '@angular/common/http';
import {RequestService} from "./request.service";
import {Router} from '@angular/router';
import { SocketConnectionService } from './socketConnection.service';

@Injectable({
  providedIn: 'root'
})
export class RefreshTokenService {

  private isRefreshingToken = false;
  private tokenSubject: BehaviorSubject<string> = new BehaviorSubject<string>(null!);

  constructor(public authService: RequestService, public router: Router, private socketConnect: SocketConnectionService) {}


  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpSentEvent | HttpHeaderResponse |
    HttpProgressEvent | HttpResponse<any> | HttpUserEvent<any>> {
    return next.handle(request).pipe(
      catchError(error => {

        if (error instanceof HttpErrorResponse) {
          if (request.url.includes('refresh') ||
            request.url.includes('login') || request.url.includes('rooms') || request.url.includes('friends/list?joint_room_type=2')) {
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
      return this.logoutUser();
    }

    return observableThrowError(error);
  }

  handle401Error(request: HttpRequest<any>, next: HttpHandler) {
    if (!this.isRefreshingToken) {
      this.isRefreshingToken = true;
      this.tokenSubject.next(null!);

      const authService = this.authService;

      return authService.refreshToken().pipe(
        switchMap((newToken: any) => {
          if (newToken && newToken !== 'error') {
            this.tokenSubject.next(newToken);
            return next.handle(this.getNewRequest(request, newToken));
          }
          return this.logoutUser();
        }),
        finalize(() => {
          this.isRefreshingToken = false;
          this.socketConnect.invokeEvent = new BehaviorSubject<boolean>(false);
          this.socketConnect.connect();
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
    if (!newAccessToken) {
      return request;
    }
    if (request.headers.getAll('')) {

    }
    return request.clone({
      setHeaders: {
        Authorization: 'Bearer ' + newAccessToken
      }
    });
  }

  logoutUser() {
    let countryCode = localStorage.getItem('countryCode') as string;
    let shortCode = localStorage.getItem('shortCode')as string;
    localStorage.clear();
    localStorage.setItem('countryCode', countryCode);
    localStorage.setItem('shortCode', shortCode);
    this.router.navigate([`/login`]);
    return observableThrowError('');
  }
}
