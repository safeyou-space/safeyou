import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {RequestService} from "../../../shared/request.service";
import {HelperService} from "../../../shared/helper.service";
import {ActivatedRoute, Router} from "@angular/router";
import {environment} from "../../../../environments/environment.prod";
import {translations} from "../../../../assets/language/translation";

@Component({
  selector: 'app-user-invite',
  templateUrl: './user-invite.component.html',
  styleUrls: ['./user-invite.component.css']
})
export class UserInviteComponent implements OnInit {
  @Output() closePage = new EventEmitter();
  url: any;
  language: any;
  country: any;
  form!:FormGroup;
  @Output() getEvent = new EventEmitter();
  imageValue: any;
  editImagePath: any;
  imagePath: any;
  image: any;
  itemList: any = [];
  settings = {};
  file: any;
  id: any;

  constructor(public requestService: RequestService,
              public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public fb: FormBuilder,
              private router: Router) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
    this.helperService.translation = translations[this.activateRoute.snapshot.params.language];
    this.form = this.fb.group({
      file: [null, Validators.required],
      first_name: [null, Validators.required],
      last_name: [null, Validators.required],
      email: [null,  Validators.compose([Validators.required, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,10}$/)])],
      phone: [null, Validators.compose([Validators.required, Validators.pattern(/^\+?([0-9]{8,})$/)])],
      password: ['', Validators.required],
      password_confirmation: ['', Validators.required]
    },{validator: this.helperService.matchingPasswords('password', 'password_confirmation')});
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.registration}`;

    this.form.controls.email.disable();
    this.form.patchValue({
      email: this.activateRoute.queryParams['_value'].email
    })
  }

  onSubmit(form) {
    if(this.form.valid) {
      let formData = new FormData();
      formData.append('first_name', form.first_name);
      formData.append('last_name', form.last_name);
      formData.append('phone', form.phone);
      formData.append('password', form.password);
      formData.append('password_confirmation', form.password_confirmation);
      if (this.file) {
        formData.append('image', this.file);
      }
      this.requestService.createData(this.url + `?token=${this.activateRoute.queryParams['_value'].token}&email=${this.activateRoute.queryParams['_value'].email}&role=${this.activateRoute.queryParams['_value'].role}'`, formData).subscribe((res) => {
        this.form.reset();
        this.router.navigateByUrl(`login`);
      });
    }
  }

  onChange(e) {
    if (e.target.files[0]) {
      this.file = e.target.files[0];
      const fileName = e.target.files[0].name;
      if (/\.(jpe?g|png|bmp)$/i.test(fileName)) {
        const filesize = e.target.files[0].size;
        if (filesize > 15728640) {
          this.form.controls.file.setErrors({size: 'error'});
        } else {
          let reader = new FileReader();
          reader.readAsDataURL(e.target.files[0]);
          reader.onload = () => {
            this.imageValue = reader.result;
          };
          this.image = e.target.files[0];
        }
      } else {
        this.form.controls.file.setErrors({type: 'error'});
      }
    } else {
      this.file = undefined;
      this.imageValue = undefined;
      this.form.controls.file.setErrors(null);
    }
  }

}
