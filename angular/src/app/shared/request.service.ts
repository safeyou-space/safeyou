import {Injectable } from '@angular/core';
import {HttpClient, HttpErrorResponse, HttpHeaders} from "@angular/common/http";
import {Observable, Subject, throwError} from 'rxjs';
import {catchError, finalize, map} from 'rxjs/operators';
import {environment} from "../../environments/environment.prod";

@Injectable({
  providedIn: 'root'
})
export class RequestService {
  httpHeaders: any;
  imgPrefix = environment.url;
  imgSite = environment.imagePrefix;
  userInfo: any = {
    id: localStorage.getItem('id'),
  };
  private viewID =  new Subject;
  dataId = this.viewID.asObservable();
  private isloading = new Subject<object>();
  reqCount = 0;
  loading = this.isloading.asObservable();


  constructor(private http: HttpClient) {
  }

  getViewId(id) {
    this.viewID.next(id)
  }

  private handleError(error: HttpErrorResponse) {
    let errorMessage;
    if (error.error instanceof ErrorEvent) {
      errorMessage = 'An error occurred:', error.error.message;
    } else {
      errorMessage = `${error.error?.message}`;
    }
    return throwError(errorMessage);
  }

  getData(apiUrl, socket?) {
    this.isloading.next({type: 'get', isLoading: true, reqCount: ++this.reqCount});
    this.httpHeaders = new HttpHeaders({
      Authorization: (!socket && localStorage.getItem('token_type') ? localStorage.getItem('token_type')  + ' ': '') + localStorage.getItem('access_token'),
      _: `${localStorage.getItem('_')}`,
      'Accept-Language': 'en'
    });
    this.httpHeaders = this.httpHeaders.set(
      'Accept-Language',
      localStorage.getItem('Accept-Language') ? localStorage.getItem('Accept-Language') : 'en'
    );
    return this.http.get(apiUrl, {headers: this.httpHeaders, observe: 'body'}).pipe(
      finalize(() => {
        this.isloading.next({type: 'get', isLoading: false, reqCount: --this.reqCount})}),
      catchError(this.handleError)
    );
  }

  createData(url, value?, socket?): Observable<any> {
    this.isloading.next({type: 'create', isLoading: true, reqCount: ++this.reqCount});
    this.httpHeaders = new HttpHeaders({
      Authorization: (!socket && localStorage.getItem('token_type') ? localStorage.getItem('token_type')  + ' ': '') + localStorage.getItem('access_token'),
      _: `${localStorage.getItem('_')}`,
      'Accept-Language': 'en'
    });
    this.httpHeaders = this.httpHeaders.set(
      'Accept-Language',
      localStorage.getItem('Accept-Language') ? localStorage.getItem('Accept-Language') : 'en'
    );
    return this.http.post<any>(url, value, {headers: this.httpHeaders})
      .pipe(
        finalize(() => {
          this.isloading.next({type: 'create', isLoading: false, reqCount: --this.reqCount});
        }),
        catchError(this.handleError)
      );
  }

  delete(url, id): Observable<{}> {
    this.isloading.next({type: 'delete', isLoading: true, reqCount: ++this.reqCount});
    this.httpHeaders = new HttpHeaders({
      Authorization: localStorage.getItem('token_type') + ' ' + localStorage.getItem('access_token')
    });
    this.httpHeaders = this.httpHeaders.set(
      'Accept-Language',
      localStorage.getItem('Accept-Language') ? localStorage.getItem('Accept-Language') : 'en'
    );
    const urlApi = `${url}/${id}`;
    return this.http.delete(urlApi, {headers: this.httpHeaders})
      .pipe(
        finalize(() => {
          this.isloading.next({type: 'delete', isLoading: false, reqCount: --this.reqCount});
        }),
        catchError(this.handleError)
      );
  }

  updateData(url, value, id) {
    this.isloading.next({type: 'update', isLoading: true, reqCount: ++this.reqCount});
    this.httpHeaders = new HttpHeaders({
      Authorization: localStorage.getItem('token_type') + ' ' + localStorage.getItem('access_token')
    });
    this.httpHeaders = this.httpHeaders.set(
      'Accept-Language',
      localStorage.getItem('Accept-Language') ? localStorage.getItem('Accept-Language') : 'en'
    );
    const urlApi = `${url}/${id}`;
    return this.http.put<any>(urlApi, value, {headers: this.httpHeaders})
      .pipe(
        finalize(() => {
          this.isloading.next({type: 'update', isLoading: false, reqCount: --this.reqCount});
        }),
        catchError(this.handleError)
      );
  }

  refreshToken(): Observable<String> {
    let countryCode = localStorage.getItem('countryCode') ? localStorage.getItem('countryCode') : 'arm';
    let shortCode = localStorage.getItem('shortCode') ? localStorage.getItem('shortCode') : 'hy';
    const url = `${environment.baseUrl}/${countryCode}/${shortCode}/${environment.admin.refresh}`;
    const header = new HttpHeaders()
      .set('Authorization', 'Bearer ' + localStorage.getItem('access_token'))
      .set('Content-Type', 'application/json');
    const body = {
      'refresh_token': localStorage.getItem('refresh_token')
    };

    return this.http.post(url, body, {headers: header})
      .pipe(
        map(data => {
          if (data && data['access_token']) {
            localStorage.setItem('access_token', data['access_token']);
            localStorage.setItem('refresh_token', data['refresh_token']);
            return data['access_token'];
          }
          return data;
        })
      );
  }
}
