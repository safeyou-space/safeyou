import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {environment} from "../../../../../../environments/environment.prod";
import {RequestService} from "../../../../../shared/request.service";
import {HelperService} from "../../../../../shared/helper.service";
import {ActivatedRoute} from "@angular/router";
import {FormControl, FormGroup, Validators} from "@angular/forms";
import {ToastrService} from "ngx-toastr";

@Component({
  selector: 'app-user-roles-create-update',
  templateUrl: './user-roles-create-update.component.html',
  styleUrls: ['./user-roles-create-update.component.css']
})
export class UserRolesCreateUpdateComponent implements OnInit {
  @Output() closePage = new EventEmitter();
  url: any;
  language: any;
  country: any;
  form = new FormGroup({
    email: new FormControl('', Validators.compose([Validators.required, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,10}$/)])),
    role: new FormControl('', Validators.required),
  });
  roles: any;

  constructor(public requestService: RequestService,
              public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              private toastr: ToastrService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.appAdmin.get}`;

    this.requestService.getData(this.url + '/roles').subscribe((res) => {
      this.roles = res;
    });
  }

  onSubmit(form) {
    if (this.form.valid) {
      this.requestService.createData(this.url + '/invite', form).subscribe((res) => {
        this.form.reset();
        this.closePage.emit('close');
      })
    } else {
      let showError = '';
      for (let i in this.form.controls) {
        if (this.form.controls[i].status == "INVALID") {
          showError += `${this.helperService.translation[i] + ' ' + this.helperService.translation?.is_required} \n`
        }
      }
      this.toastr.error(showError);
      this.form.markAllAsTouched();
    }
  }

  togglePage() {
    this.form.reset();
    this.closePage.emit('close')
  }
}
