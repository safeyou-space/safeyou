import {Injectable} from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {Observable, Subject} from 'rxjs';
import {ActivatedRoute, Router} from '@angular/router';
import {finalize, map} from 'rxjs/operators';
import {AlertService} from "ngx-alerts";
import {navItems} from "../../_nav";
import {environment} from "../../../environments/environment.prod";

@Injectable({
  providedIn: 'root'
})
export class RequestService {
  errorMessage;
  reqCount = 0;
  public currentToken: string;
  private isloading = new Subject<object>();
  loading = this.isloading.asObservable();
  activeCountryCode: any;
  patterns = {
    uri: '^[a-zA-Z0-9/_%-]+$',
    url: /[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&=]*)/,
    order: '[0-9]+$',
    phone: /^\+?([0-9]{8,})$/,
    latitude: /^(\+|-)?(?:90(?:(?:\.0{1,6})?)|(?:[0-9]|[1-8][0-9])(?:(?:\.[0-9]{1,6})?))$/,
    longitude: /^(\+|-)?(?:180(?:(?:\.0{1,6})?)|(?:[0-9]|[1-9][0-9]|1[0-7][0-9])(?:(?:\.[0-9]{1,6})?))$/,
    latitudeAndLongitude: /^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$/
  };
  userInfo: any = {
    first_name: localStorage.getItem('first_name'),
    last_name: localStorage.getItem('last_name'),
    role: localStorage.getItem('role'),
    image: localStorage.getItem('image'),
    isSuperAdmin: localStorage.getItem('is_super_admin'),
    isAdmin: localStorage.getItem('is_admin')
  };
  ckEditorConfig: Object = {
    uiColor:  '#CCEAEE', removeButtons : 'Save', autoParagraph: false, allowedContent: true
  };
  paginationConfig: any = {
    totalItems: '',
    perPage: '',
    paginationMaxSize: 10,
    currentPage: 1,
  };
  menuItems;
  reply;
  notificationList: any = [];

  constructor(public router: Router,
              private http: HttpClient,
              private alertService: AlertService,
              public activeRoute: ActivatedRoute
  ) {
    this.currentToken = localStorage.getItem('access_token');
    this.activeCountryCode = this.activeRoute.snapshot.params['code'];
  }

  // get http request function
  getData(dataUrl, params = true) {
    if (params && (this.userInfo.isSuperAdmin == 'true' || this.userInfo.isAdmin == 'true')) {
      this.getNotificationList();
    }
    this.isloading.next({type: 'get', isLoading: true, reqCount: ++this.reqCount});
    const url = dataUrl;
    const header = new HttpHeaders()
      .set('Authorization', 'Bearer ' + localStorage.getItem('access_token'))
      .set('Content-Type', 'application/json')
      .set('Accept', 'application/json');
    const request = this.http.get(url, {
      headers: header,
      observe: 'body'
    }).pipe(
      finalize(() => {
        this.isloading.next({type: 'get', isLoading: false, reqCount: --this.reqCount});
      })
    );
    return request;

  }

  // post http request function
  createData(dataUrl, create, file = true) {
    this.isloading.next({type: 'create', isLoading: true, reqCount: ++this.reqCount});
    const url = dataUrl;
    const header = new HttpHeaders()
      .set('Authorization', 'Bearer ' + localStorage.getItem('access_token'));
    if (file) {
      header.set('Content-Type', 'application/json');
    }
    const request = this.http.post(url,
      create, {
        headers: header
      }).pipe(
      finalize(() => {
        this.isloading.next({type: 'create', isLoading: false, reqCount: --this.reqCount});
      })
    );
    return request;
  }
  // put http request function
  updateData(dataUrl, update, id) {
    this.isloading.next({type: 'update', isLoading: true, reqCount: ++this.reqCount});
    const url = `${dataUrl}/${id}`;
    const header = new HttpHeaders()
      .set('Authorization', 'Bearer ' + localStorage.getItem('access_token'))
      .set('Content-Type', 'application/json');
    const request = this.http.put(url,
      update, {
        headers: header
      }).pipe(
      finalize(() => {
        this.isloading.next({type: 'update', isLoading: false, reqCount: --this.reqCount});
      })
    );
    return request;
  }

  // delete http request function
  delete(dataUrl, id) {
    this.isloading.next({type: 'delete', isLoading: true, reqCount: ++this.reqCount});
    const url = `${dataUrl}/${id}`;
    const header = new HttpHeaders()
      .set('Authorization', 'Bearer ' + localStorage.getItem('access_token'))
      .set('Accept', 'application/json');
    const request = this.http.delete(url,
      {
        headers: header
      }).pipe(
      finalize(() => {
        this.isloading.next({type: 'delete', isLoading: false, reqCount: --this.reqCount});
      })
    );
    return request;
  }

  // check returned Status code function
  StatusCode(error) {
    if (error.status === 500) {
      this.router.navigate(['500']);
    } else if (error.status === 401) {
      window.localStorage.clear();
      this.router.navigate([`administrator/${this.activeCountryCode}/login`]);
    } else if (error.status === 422) {
      this.errorMessage = '';
      if (error.error.message) {
        for (const item of Object.keys(error.error.message)) {
          this.errorMessage += error.error.message[item] + '\n';
        }
        this.alertService.danger(this.errorMessage);
      }
    } else if (error.status === 400) {
      this.alertService.danger(error.error.message);
    } else if (error.status === 403) {
        this.router.navigate(['403']);
    } else if (error.status === 404) {
      this.router.navigate(['404']);
    }
  }

  // get Menu List function
  getMenuList () {
    this.menuItems = undefined;
    setTimeout(() => {
      for (let i = 0; i < navItems.length; i++) {
        if (navItems[i].children) {
          for (let j = 0; j < navItems[i].children.length; j++) {
            navItems[i].children[j].url = `/administrator/${this.activeCountryCode}${navItems[i].children[j].uri}`;
          }
        } else {
          navItems[i].url = `/administrator/${this.activeCountryCode}${navItems[i].uri}`;
        }

      }
      if (localStorage.getItem('is_super_admin') == 'true') {
        this.menuItems = navItems;
      } else if (localStorage.getItem('access')){
        let access = JSON.parse(localStorage.getItem('access'));
        let newMenuList = [];
        for (let i = 0; i < navItems.length; i++) {
          if (navItems[i].children) {
            let childrens = [];
            for (let j = 0; j < navItems[i].children.length; j++) {
              if (access[navItems[i].children[j].key]) {
                childrens.push(navItems[i].children[j])
              }
            }
            if (childrens.length) {
              let obj = {};
              obj['name'] = navItems[i].name;
              obj['url'] = navItems[i].url;
              obj['icon'] = navItems[i].icon;
              obj['children'] = childrens;
              newMenuList.push(obj);
            }
          } else {
            if (access[navItems[i].key]) {
              newMenuList.push(navItems[i]);
            }
          }
        }
        this.menuItems = newMenuList;
      } else {
        this.menuItems = navItems;
      }
    }, 10);

  }


  // get new access token and send refresh token
  refreshToken(): Observable<String> {
    const url = `${environment.endpoint}${this.activeCountryCode}${environment.refresh}`;
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
            localStorage.setItem('expires_in', data['expires_in']);
            localStorage.setItem('refresh_token', data['refresh_token']);
            return data['access_token'];
          }
          return data;
        })
      );
  }


  // get notification list function
  getNotificationList () {
    this.getData(`${environment.endpoint}${this.activeCountryCode}${environment.contactUs.getContactUsActiveList}`, false).subscribe(res => {
      this.notificationList = res;
    }, error => {
      this.StatusCode(error);
    });
  }
}
