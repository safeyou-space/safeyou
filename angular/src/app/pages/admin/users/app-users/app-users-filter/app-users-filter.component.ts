import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {HelperService} from "../../../../../shared/helper.service";
import {ActivatedRoute} from "@angular/router";
import {FormBuilder} from "@angular/forms";
import {RequestService} from "../../../../../shared/request.service";
import {environment} from "../../../../../../environments/environment.prod";

@Component({
  selector: 'app-app-users-filter',
  templateUrl: './app-users-filter.component.html',
  styleUrls: ['./app-users-filter.component.css']
})
export class AppUsersFilterComponent implements OnInit {

  @Output() closeFilter = new EventEmitter();
  @Output() filter = new EventEmitter();
  @Input() allData;
  language: any;
  country: any;
  data: any;
  url: string = '';
  categoryList: any = [];
  form = this.fb.group({
    marital_status : [''],
    age_restricted: [''],
    is_has_emergency_contacts: [''],
    check_police : ['']
  });
  categoryIds: any = [];
  filterValues: any = '';


  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public fb: FormBuilder,
              public requestService: RequestService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.marital_statuses}`;
  }

  ngOnInit(): void {
    this.getCategoryList(this.url);
    this.form.valueChanges.subscribe((item) => {
      setTimeout(() => {
        this.filterValues = '';
        let obj = {};
        for (let i = 0; i < this.categoryIds.length; i++) {
          obj[i.toString()] = this.categoryIds[i];
        }
        this.filterValues += Object.keys(obj).length != 0 ? `&marital_status=${this.categoryIds[0]}` : '';
        this.filterValues += (this.form.value['age_restricted'] === true || this.form.value['age_restricted'] === false) ?`&age_restricted=${this.form.value['age_restricted'] ? 1 : 0}` : '';
        this.filterValues += (this.form.value['is_has_emergency_contacts'] === true || this.form.value['is_has_emergency_contacts'] === false) ?`&is_has_emergency_contacts=${this.form.value['is_has_emergency_contacts'] ? 1 : 0}` : '';
        this.filterValues += (this.form.value['check_police'] === true || this.form.value['check_police'] === false) ?`&check_police=${this.form.value['check_police'] ? 1 : 0}` : '';
      }, 0)
    })
  }

  close() {
    this.closeFilter.emit('close');
  }

  getCategoryList (url) {
    this.requestService.getData(url).subscribe((items) => {
      for (let i in items) {
        this.categoryList.push({
          id: items[i].type,
          value: items[i].label
        })
      }
    });
  }

  changeInputValue(event, id) {
    this.categoryIds.splice(0);
    this.categoryIds.push(id);
  }

  clearValues() {
    this.form.reset();
    this.categoryIds.splice(0);
    this.filter.emit('');
  }
  save() {
    this.filter.emit(this.filterValues);
  }

}
