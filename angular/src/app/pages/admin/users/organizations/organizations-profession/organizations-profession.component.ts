import {Component, EventEmitter, OnInit, Output, ViewChild} from '@angular/core';
import {FormArray, FormBuilder, FormGroup, Validators} from "@angular/forms";
import {animate, state, style, transition, trigger} from "@angular/animations";
import {HelperService} from "../../../../../shared/helper.service";
import {RequestService} from "../../../../../shared/request.service";
import {ActivatedRoute} from "@angular/router";
import {environment} from "../../../../../../environments/environment.prod";
import {DeleteModalComponent} from "../../../../../components/utils/delete-modal/delete-modal.component";
import {ToastrService} from "ngx-toastr";

@Component({
  selector: 'app-organizations-profession',
  templateUrl: './organizations-profession.component.html',
  styleUrls: ['./organizations-profession.component.css'],
  animations: [
    trigger('page', [
      // ...
      state('open', style({
        opacity: '1',
        visibility: 'visible',
      })),
      state('closed', style({
        opacity: 0,
        visibility: 'hidden',
      })),
      transition('open <=> closed', [
        animate('0.8s ease-in-out')
      ]),
    ]),
  ]
})
export class OrganizationsProfessionComponent implements OnInit {
  @ViewChild(DeleteModalComponent) private modal!: DeleteModalComponent;
  public formProfession: any = FormGroup;
  addProfession = false;
  @Output() myEvent = new EventEmitter();
  language: any;
  country: any;
  data: any;
  url: string = '';
  languageList: any;
  type: string = '';
  itemId: any;
  allPageData: any;
  sortingValue: any = {};

  constructor(private fb: FormBuilder,
              public requestService: RequestService,
              public activateRoute: ActivatedRoute,
              public helperService: HelperService,
              private toastr: ToastrService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.editForm();
  }

  ngOnInit(): void {
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.organization.getCategoryList}`;
    this.getProfessionList(this.url);
    this.getLanguageList();
  }

  close(){
    this.myEvent.emit('close')
  }

  urlConstructor() {
    let sorting =  Object.keys(this.sortingValue).length == 0 ? '' : `&sorts=${JSON.stringify(this.sortingValue)}`;
    let url = `${this.url}?page=${this.allPageData?.current_page}${sorting}`;
    return url;
  }

  editForm() {
    this.formProfession = this.fb.group({
      title: ['', Validators.required],
      translations: this.fb.array([]),
      status: ['']
    });
  }

  onSubmitProfession(form, status) {
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
    if (this.formProfession.valid) {
      if(this.type == 'add') {
        this.createProfession(formData);
      } else {
        this.editProfession(formData)
      }
    } else {
      let showError = '';
      for (let i in this.formProfession.controls) {
        if (this.formProfession.controls[i].status == "INVALID") {
          if (i != 'translations') {
            showError += `${this.helperService.translation[i] + ' ' + this.helperService.translation?.is_required} \n`
          }
        }
      }

      for (let j in this.formProfession.controls.translations.controls) {
        if (this.formProfession.controls.translations.controls[j].status == "INVALID") {
          for (let k in this.formProfession.controls.translations.controls[j].controls) {
            if (this.formProfession.controls.translations.controls[j].controls[k].status == "INVALID") {
              showError += `${this.helperService.translation[k].charAt(0).toUpperCase() + this.helperService.translation[k].slice(1) + ' ' + this.helperService.translation?.is_required} \n`
            }
          }
        }
      }
      this.toastr.error(showError);
      this.formProfession.markAllAsTouched();
    }
  }

  createProfession(data) {
    this.requestService.createData(this.url, data).subscribe((items) => {
      this.getProfessionList(this.urlConstructor());
      this.formProfession.reset();
      this.addProfession = false;
    })
  }

  editProfession (data) {
    this.requestService.updateData(this.url, data, this.itemId).subscribe((items) => {
      this.getProfessionList(this.urlConstructor());
      this.formProfession.reset();
      this.addProfession = false;
    })
  }


  cancelProfession() {
    this.formProfession.reset();
    this.addProfession = false;
  }

  addTechnology(tech = '') {
    const control = <FormArray>this.formProfession.controls['translations'];
    for(let i in this.languageList) {
      let form = {};
      let value = tech[i] ? tech[i].translation : '';
      form[this.languageList[i].code] = [value, Validators.required];
      control.push(this.fb.group(form));
    }
    this.formProfession.controls.translations.updateValueAndValidity();
  }

  removeTechnology(i: number) {
    const control = <FormArray>this.formProfession.controls['translations'];
    while (control.length) {
      control.removeAt(0);
    }
  }

  getLanguageList(){
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.getLanguageList}`).subscribe((items: any) => {
      this.languageList = items;
    })
  }

  getProfessionList(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.data = items['data'] ? items['data'] : items;
      this.allPageData = items;
    })
  }

  deleteItem(id) {
    this.modal.modalRef.hide();
    this.requestService.delete(this.url, id).subscribe((item) => {
      this.allPageData.current_page = (this.allPageData.current_page > 1 && this.allPageData.data.length == 1) ?  this.allPageData.current_page - 1 : this.allPageData.current_page;
      this.getProfessionList(this.urlConstructor());
    })
  }

  showForm (item?) {
    this.removeTechnology(0);
    this.formProfession.reset();
    if (item) {
      this.itemId = item.id;
      this.formProfession.patchValue({
        title: item.title
      });
      this.addTechnology(item.translations);
    }
    this.addProfession = true;
    this.type = item ? 'edit' : 'add';
  }

  pageChanged(event) {
    this.allPageData.current_page = event.page;
    this.getProfessionList(this.urlConstructor());
  }
  sorting(value, type?) {
    if (this.sortingValue[value]) {
      this.sortingValue[value] = this.sortingValue[value] == 'ASC' ? 'DESC' : !delete this.sortingValue[value];
    } else {
      this.sortingValue = {};
      this.sortingValue[value] = type;
    }
    if(this.sortingValue[value] == false) {
      this.sortingValue = {};
    }
    this.getProfessionList(this.urlConstructor());
  }
}
