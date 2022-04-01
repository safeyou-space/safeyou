import {
  AfterViewChecked,
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  Input,
  OnDestroy,
  OnInit, Output,
  EventEmitter
} from '@angular/core';
import {HelperService} from "../../shared/helper.service";
import {ActivatedRoute, Router} from "@angular/router";
import {RequestService} from "../../shared/request.service";
import {apiUrl, environment} from "../../../environments/environment.prod";
import {translations} from "../../../assets/language/translation";
import {SocketConnectionService} from 'src/app/shared/socketConnection.service';
import {FormBuilder, Validators} from "@angular/forms";

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class HeaderComponent implements OnInit, AfterViewChecked, OnDestroy {

  @Input() isShowSearch: any = true;
  @Input() isShowMenu: any = true;
  language: any;
  country: any;
  access: any = [];
  is_admin: any;
  imageUrl = apiUrl;
  notifications: any;
  searchForm = this.fb.group({
    search: ['', Validators.required]
  });
  @Output() searchEvent = new EventEmitter<string>();

  date:any = new Date();

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public requestService: RequestService,
              private router: Router,
              public fb: FormBuilder,
              public socketConnect: SocketConnectionService,
              private cd: ChangeDetectorRef) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnDestroy(): void {
    this.searchForm.reset()
  }

  ngOnInit(): void {
    this.access = JSON.parse(localStorage.getItem('access')!);
    this.is_admin = JSON.parse(localStorage.getItem('is_admin')!);
    if (this.isShowMenu) {
      this.helperService.changeMenuItem(false);
    } else {
      this.helperService.changeMenuItem(true);
    }
    if (this.language != localStorage.getItem('shortCode')) {
      localStorage.setItem('shortCode', this.language)
    }
    this.helperService.translation = translations[this.helperService.defaultLanguage];
    if (!this.helperService.activeLanguage) {
      this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.getLanguageList}`).subscribe((res) => {
        this.helperService.languageList = res;
        for (let i = 0; i < this.helperService.languageList.length; i++) {
          if (this.helperService.languageList[i].code == localStorage.getItem('shortCode')) {
            this.helperService.activeLanguage = this.helperService.languageList[i];
          }
        }
      })
    }
    this.socketConnect.notifications.subscribe(res => {
      if (res) {
        this.notifications = res['data'];
      }
    })
  }

  getMinutes(paramDate) {
    let current = new Date();
    let old = new Date(paramDate);
    let days = Math.ceil(Math.abs(old.getTime() - current.getTime()) / (1000 * 3600 * 24));
    let h = Math.ceil(Math.abs(old.getTime() - current.getTime()) / (1000 * 3600));
    let m = Math.ceil(Math.abs(old.getTime() - current.getTime()) / (1000 * 60));
    let s = Math.ceil(Math.abs(old.getTime() - current.getTime()) / (1000));
    let year = Math.floor(days / 365);
    let months = Math.floor((days - (year * 365)) / 30);
    if (m > 0 && m < 60) {
      return m + ' ' + this.helperService.translation?.minute
    } else if (m < 1) {
      return s + ' ' + this.helperService.translation?.second;
    } else {
      days -= 1;

      if (year > 0) {
        return year + ' ' + this.helperService.translation?.year;
      } else if (days > 30) {
        return months + ' ' + this.helperService.translation?.month;
      } else {
        if (days == 0) {
          return h + ' ' + this.helperService.translation?.time.toLowerCase();
        }
        return days + ' ' + this.helperService.translation?.day;
      }
    }

  }

  ngAfterViewChecked() {
    this.cd.detectChanges();
  }

  getter(notification, type?) {
    this.socketConnect.socket.emit('signal', 18, {
      notify_id: notification.notify_id
    });
    for (let not of this.notifications) {
      if (not.notify_id == notification.notify_id) {
        not.notify_read = 1;
      }
    }

    if (type == 'new') {
      if (notification.body.message_id) {
        this.socketConnect.newNotifications = this.socketConnect.newNotifications.filter(res => res.body.message_id != notification.body.message_id);
      } else {
        this.socketConnect.newNotifications = this.socketConnect.newNotifications.filter(res => res.body.id != notification.body.id);
      }
    }

    this.socketConnect.navigateForum.next(notification);
    this.router.navigateByUrl(`${this.country}/${this.language}/forum`);
  }

  getterReport(notification) {
    this.socketConnect.socket.emit('signal', 18, {
      notify_id: notification.notify_id
    });
    for (let not of this.notifications) {
      if (not.notify_id == notification.notify_id) {
        not.notify_read = 1;
      }
    }
    this.socketConnect.newNotifications = this.socketConnect.newNotifications.filter(res => res.body.id != notification.body.id);
  }

  goCommunication (index) {
    this.socketConnect.newNotifications.splice(index, 1);
    this.router.navigateByUrl(`${this.country}/${this.language}/communication`);
  }

  logOut() {
    this.requestService.createData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.logout}`, '').subscribe(() => {
      let countryCode = localStorage.getItem('countryCode') as string;
      let shortCode = localStorage.getItem('shortCode') as string;
      localStorage.clear();
      localStorage.setItem('countryCode', countryCode);
      localStorage.setItem('shortCode', shortCode);
      this.router.navigateByUrl('login');
    })

  }
  timeOut
  handleInput() {
    if (this.searchForm.value.search.trim().length > 0 && this.searchForm.valid) {
      clearTimeout(this.timeOut);
      this.timeOut = setTimeout(() => {
        this.searchEvent.emit(this.searchForm.value);
      }, 1000);
    }
  }
  clearSearchValue() {
    this.searchForm.reset({search: ''});
    this.searchEvent.emit('');
  }

}
