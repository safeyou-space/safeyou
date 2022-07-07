import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {FormArray, FormBuilder, Validators} from "@angular/forms";
import {RequestService} from "../../../../../shared/request.service";
import {ActivatedRoute} from "@angular/router";
import {ToastrService} from "ngx-toastr";
import {HelperService} from "../../../../../shared/helper.service";
import {environment} from "../../../../../../environments/environment.prod";

@Component({
  selector: 'app-translations-edit-create',
  templateUrl: './translations-edit-create.component.html',
  styleUrls: ['./translations-edit-create.component.css']
})
export class TranslationsEditCreateComponent implements OnInit {
  @Output() closePage = new EventEmitter();
  static instance: TranslationsEditCreateComponent;
  form = this.fb.group({
    key: ['', Validators.required],
    translations: this.fb.array([]),
    status: ['']
  });
  url: string = '';
  language: any;
  country: any;
  languageList: any;
  type: any;
  key;

  constructor(public fb: FormBuilder,
              public requestService: RequestService,
              public activateRoute: ActivatedRoute,
              private toastr: ToastrService,
              public helperService: HelperService) {
    TranslationsEditCreateComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.translations.get}`;
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
          if (i != 'translations') {
            showError += `${this.helperService.translation[i] + ' ' + this.helperService.translation?.is_required} \n`
          }
        }
      }

      for (let j in this.form.controls.translations['controls']) {
        if (this.form.controls.translations['controls'][j].status == "INVALID") {
          for (let k in this.form.controls.translations['controls'][j].controls) {
            if (this.form.controls.translations['controls'][j].controls[k].status == "INVALID") {
              showError += `${this.helperService.translation[k].charAt(0).toUpperCase() + this.helperService.translation[k].slice(1) + ' ' + this.helperService.translation?.is_required} \n`
            }
          }
        }
      }
      this.toastr.error(showError);
    }
  }

  createProfession(data) {
    this.requestService.createData(this.url, data).subscribe((items) => {
      this.form.reset();
      this.closePage.emit('close-and-get');
    })
  }

  editProfession (data) {
    this.requestService.updateData(this.url, data, this.key).subscribe((items) => {
      this.form.reset();
      this.closePage.emit('close-and-get');
    })
  }

  addTechnology(tech = {}) {
    const control = <FormArray>this.form.controls['translations'];
    for(let i in this.languageList) {
      let form = {};
      let value = (tech[this.languageList[i].code]) ? tech[this.languageList[i].code]?.translation : '';
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
    this.key = undefined;
    if (item) {
      this.key = item.key;
      this.form.patchValue({
        key: item.key
      });
      this.addTechnology(item.translations);
    } else {
      this.addTechnology();
    }
    this.type = item ? 'edit' : 'add';
  }

}
