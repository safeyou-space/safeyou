import {Component, OnInit, ViewChild} from '@angular/core';
import {FormControl, FormGroup, Validators} from "@angular/forms";
import {RequestService} from "../../../shared/request.service";
import {Router} from "@angular/router";
import {environment} from "../../../../environments/environment.prod";
import {HelperService} from "../../../shared/helper.service";
import {animate, state, style, transition, trigger} from "@angular/animations";
import {translations} from "../../../../assets/language/translation";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
  animations: [
    trigger('page', [
      state('open', style({
        opacity: '1',
        visibility: 'visible',
        position: 'absolute',
        zIndex: 10,
      })),
      state('closed', style({
        opacity: '0',
        visibility: 'hidden',
        position: 'absolute',
        zIndex: 5,
      })),
      transition('open <=> closed', [
        animate('0.8s ease-in-out')
      ]),
    ]),
  ]
})
export class LoginComponent implements OnInit {

  @ViewChild("changeType") changeType: any;
  itemList: any = [];
  showPage = (localStorage.getItem('countryCode') && localStorage.getItem('shortCode')) ? false : true;
  showError: any = false;
  selectedItems: any;
  settings = {};
  itemListCountry: any;
  selectedItemsCountry: any;
  settingsCountry = {};
  form = new FormGroup({
    email: new FormControl('', Validators.compose([Validators.required, Validators.pattern(/^([\+0-9]{9,15})|([A-Za-z0-9._%\+\-]+@[a-z0-9.\-]+\.[a-z]{2,10})$/)])),
    password: new FormControl('', Validators.compose([Validators.required, Validators.minLength(8)])),
  });

  countryForm = new FormGroup({
    language: new FormControl('', Validators.required),
    country: new FormControl('', Validators.required),
  });

  constructor(private requestService: RequestService,
              private router: Router,
              public helperService: HelperService) {
  }

  ngOnInit(): void {
    this.helperService.loginTranslations = translations[this.helperService.defaultLanguage];
    this.getCountryCode();
    this.selectedItems = [];
    this.selectedItemsCountry = [];
    setTimeout(() => {
      this.settings = {
        text: "",
        selectAllText: 'Select All',
        unSelectAllText: 'UnSelect All',
        enableSearchFilter: true,
        classes: "myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false,
      };
      this.settingsCountry = {
        text: "",
        selectAllText: 'Select All',
        unSelectAllText: 'UnSelect All',
        enableSearchFilter: true,
        classes: "myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false,
      };
    },0);
  }

  onSubmit() {
    let countryCode = localStorage.getItem('countryCode');
    let shortCode = localStorage.getItem('shortCode');
    if (this.form.valid && countryCode && shortCode) {
      this.requestService.userInfo['id'] = 1;
      let form = {
        username: this.form.value.email,
        password: this.form.value.password,
      };
      this.requestService.createData(`${environment.baseUrl}/${countryCode}/${shortCode}/${environment.admin.login}`, form).subscribe((data) => {
        if (data) {
          for (let key in data) {
            localStorage.setItem(key, data[key]);
          }
          this.router.navigateByUrl(`${countryCode}/${shortCode}/dashboard`);
            if (data['access']) {
              localStorage.setItem('access', JSON.stringify(data['access']));
            }
        }
        this.helperService.languageList = undefined;
        this.helperService.activeLanguage = undefined;
      });
    } else {
      if (this.form.get('email')?.hasError('required')) {
        this.form.get('email')?.markAllAsTouched()
      }
      if (this.form.get('password')?.hasError('required')) {
        this.form.get('password')?.markAllAsTouched()
      }
      if (this.form.get('language')?.hasError('required')) {
        this.form.get('language')?.markAllAsTouched()
      }
      if (this.form.get('country')?.hasError('required')) {
        this.form.get('country')?.markAllAsTouched()
      }
    }
  }

  onItemSelect(item:any){
    this.countryForm.get('language')?.reset();
    this.getLanguageCode(item.countryCode);
  }
  closeDropdown (dropdownRef) {
    dropdownRef.closeDropdown();
  }

  deSelectCountry() {
    this.itemList = [];
  }
  changeInputType(icon) {
    let el = this.changeType.nativeElement;
    if (el.type == 'password') {
      el.type = 'text';
      icon.src = 'assets/images/icons/icon-hide.png';
    } else {
      el.type = 'password';
      icon.src = 'assets/images/icons/icon-eye.png';
    }
  }

  getCountryCode () {
    this.requestService.getData(`${environment.baseUrl}/arm/hy/${environment.admin.getCountryList}`).subscribe((items) => {
      let a = [] as any;
      let countryCode = localStorage.getItem('countryCode');
      for(let i in items) {
        if (countryCode && items[i].short_code == countryCode) {
          this.countryForm.patchValue({
            country: [
              {
                "id": items[i].id,
                "itemName": items[i].name,
                'countryCode':  items[i].short_code,
              }
            ]
          });
        }
        a.push({
          "id": items[i].id,
          "itemName": items[i].name,
          'countryCode':  items[i].short_code,
        })
      }
      this.itemListCountry = [...a];
    })
  }

  getLanguageCode (code) {
    this.requestService.getData(`${environment.baseUrl}/${code}/hy/${environment.admin.getLanguageList}`).subscribe((items) => {
      let a = [] as any;
      let shortCode = localStorage.getItem('shortCode');
      for(let i in items) {
        if (shortCode && items[i].code == shortCode) {
          this.countryForm.patchValue({
            language: [
              {
                "id": items[i].id,
                "itemName": items[i].title,
                'shortCode': items[i].code
              }
            ]
          });
          localStorage.setItem('shortCode', items[i].code);
        }
        a.push({
          "id": items[i].id,
          "itemName": items[i].title,
          'shortCode': items[i].code
        })
      }
      this.itemList = [...a];
    })
  }
  next() {
    if (this.countryForm.valid) {
      this.showPage = false;
      let countryCode = this.countryForm.value.country[0]['countryCode'];
      let shortCode = this.countryForm.value.language[0]['shortCode'];
      localStorage.setItem('countryCode', countryCode);
      localStorage.setItem('shortCode', shortCode);
      setTimeout(() => {
        this.helperService.loginTranslations = translations[shortCode];
      }, 600);
    }
  }

  changeCountryOrLanguage() {
    this.form.reset();
    this.showPage = true;
    let countryCode = this.countryForm.value.country[0]['countryCode'];
    this.getLanguageCode(countryCode);
  }

}
