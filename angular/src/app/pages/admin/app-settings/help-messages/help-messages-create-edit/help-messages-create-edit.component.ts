import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {FormArray, FormBuilder, Validators} from "@angular/forms";
import {HelperService} from "../../../../../shared/helper.service";
import {environment} from "../../../../../../environments/environment.prod";
import {RequestService} from "../../../../../shared/request.service";
import {ActivatedRoute} from "@angular/router";
import {ToastrService} from "ngx-toastr";

@Component({
  selector: 'app-help-messages-create-edit',
  templateUrl: './help-messages-create-edit.component.html',
  styleUrls: ['./help-messages-create-edit.component.css']
})
export class HelpMessagesCreateEditComponent implements OnInit {
  @Output() closePage = new EventEmitter();
  static instance: HelpMessagesCreateEditComponent;
  form = this.fb.group({
    message: ['', Validators.required],
    translations: this.fb.array([]),
    status: ['']
  });
  url: string = '';
  language: any;
  country: any;
  languageList: any;
  type: any;
  itemId;

  constructor(public fb: FormBuilder,
              public requestService: RequestService,
              public activateRoute: ActivatedRoute,
              private toastr: ToastrService,
              public helperService: HelperService) {
    HelpMessagesCreateEditComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.helpMessages.get}`;
  }

  ngOnInit(): void {
    this.getLanguageList();
  }

  closeDropdown (dropdownRef) {
    dropdownRef.closeDropdown();
  }

  togglePage() {
    this.closePage.emit('close');
  }

  onSubmit(form, status) {
    form.status = status;
    let formData = {};
    for (let i in form) {
      if (form[i] instanceof Array) {
        formData[i] = {};
        form[i].forEach((item, j) => {
          formData[i][Object.keys(item)[0]] = Object.values(item)[0];
        })
        continue;
      }
      formData[i] = form[i]
    }
    if (this.form.valid) {
      if(this.type == 'add') {
        this.createProfession(formData);
      } else {
        this.editProfession(formData)
      }
    } else {
      let showError = '';
      for (let i in this.form.controls) {
        if (this.form.controls[i].status == "INVALID") {
          showError += `${this.helperService.translation[i] + ' ' + this.helperService.translation?.is_required} \n`
        }
      }
      this.toastr.error(showError);
    }
  }

  createProfession(data) {
    this.requestService.createData(this.url, data).subscribe((items) => {
      // this.getProfessionList(this.urlConstructor());
      this.form.reset();
      this.closePage.emit('close-and-get');
      // this.addProfession = false;
    })
  }

  editProfession (data) {
    this.requestService.updateData(this.url, data, this.itemId).subscribe((items) => {
      // this.getProfessionList(this.urlConstructor());
      this.form.reset();
      this.closePage.emit('close-and-get');
      // this.addProfession = false;
    })
  }

  addTechnology(tech = '') {
    const control = <FormArray>this.form.controls['translations'];
    for(let i in this.languageList) {
      let form = {};
      let value = tech[i] ? tech[i].translation : '';
      form[this.languageList[i].code] = [value, Validators.required];
      control.push(this.fb.group(form));
    }
    this.form.controls.translations.updateValueAndValidity();
  }

  getLanguageList(){
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.getLanguageList}`).subscribe((items: any) => {
      this.languageList = items;
      this.showForm();
    })
  }

  removeTechnology(i: number) {
    const control = <FormArray>this.form.controls['translations'];
    while (control.length) {
      control.removeAt(0);
    }
  }

  showForm (item?) {
    this.removeTechnology(0);
    this.form.reset();
    if (item) {
      this.itemId = item.id;
      this.form.patchValue({
        message: item.message
      });
      this.addTechnology(item.translations);
    } else {
      this.addTechnology();
    }
    // this.addProfession = true;
    this.type = item ? 'edit' : 'add';
  }

}
