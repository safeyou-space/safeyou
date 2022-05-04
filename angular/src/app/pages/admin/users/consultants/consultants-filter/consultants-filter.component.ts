import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {HelperService} from "../../../../../shared/helper.service";
import {ActivatedRoute} from "@angular/router";
import {FormBuilder} from "@angular/forms";
import {RequestService} from "../../../../../shared/request.service";
import {environment} from "../../../../../../environments/environment.prod";

@Component({
  selector: 'app-consultants-filter',
  templateUrl: './consultants-filter.component.html',
  styleUrls: ['./consultants-filter.component.css']
})
export class ConsultantsFilterComponent implements OnInit {

  @Output() closeFilter = new EventEmitter();
  @Output() filter = new EventEmitter();
  @Input() allData;
  language: any;
  country: any;
  data: any;
  url: string = '';
  categoryList: any = [];
  form = this.fb.group({
    positions: [''],
    forums_count: [''],
    forums_comment_count:[''],
    status: ['']
  });
  categoryIds: any = [];
  filterValues: any = '';
  showAllCategoriesCount: any = 8;


  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public fb: FormBuilder,
              public requestService: RequestService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.getProfessionList}/list`;
  }

  ngOnInit(): void {
    this.getCategoryList(this.url);
    this.form.valueChanges.subscribe((item) => {
      setTimeout(() => {
        this.filterValues = '';
        for (let item in this.form.value) {
          if (item != 'positions' && this.form.value[item] && item != 'status') {
            this.filterValues += `&${item}=${encodeURIComponent(this.form.value[item])}`
          }
        }
        let obj = {};
        for (let i = 0; i < this.categoryIds.length; i++) {
          obj[i.toString()] = this.categoryIds[i];
        }
        this.filterValues += Object.keys(obj).length != 0 ? `&positions=${JSON.stringify(obj)}` : '';
        this.filterValues += (this.form.value['status'] === true || this.form.value['status'] === false) ?`&status=${this.form.value['status'] ? 1 : 0}` : '';
        }, 0);
    })
  }

  close() {
    this.closeFilter.emit('close');
  }

  getCategoryList (url) {
    this.requestService.getData(url).subscribe((items) => {
      for (let i in items) {
        this.categoryList.push({
          id: i,
          value: items[i]
        })
      }
    });
  }

  changeInputValue(event, id) {
    if (this.categoryIds.indexOf(id) == -1) {
      this.categoryIds.push(id);
    } else {
      this.categoryIds.splice(this.categoryIds.indexOf(id), 1);
    }
  }

  clearValues() {
    this.form.reset();
    this.categoryIds.splice(0);
    this.filter.emit('');
  }
  save() {
    if (this.filterValues != '') {
      this.filter.emit(this.filterValues);
    }
  }

  showAllCategories() {
    this.showAllCategoriesCount = this.categoryList.length ? this.categoryList.length : 8;
  }

}
