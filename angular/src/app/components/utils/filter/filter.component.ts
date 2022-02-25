import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {HelperService} from "../../../shared/helper.service";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../shared/request.service";
import {environment} from "../../../../environments/environment.prod";
import {FormBuilder} from "@angular/forms";

@Component({
  selector: 'app-filter',
  templateUrl: './filter.component.html',
  styleUrls: ['./filter.component.css']
})
export class FilterComponent implements OnInit {

  @Output() closeFilter = new EventEmitter();
  @Output() filter = new EventEmitter();
  @Input() allData;
  language: any;
  country: any;
  data: any;
  url: string = '';
  categoryList: any = [];
  form = this.fb.group({
    categories: [''],
    views_count: [''],
    comments_count:[''],
    age_restricted: ['']
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
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.forum.getAllCategoryList}`;
  }

  ngOnInit(): void {
    this.getCategoryList(this.url);
    this.form.valueChanges.subscribe((item) => {
      setTimeout(() => {
        this.filterValues = '';
        for (let item in this.form.value) {
          if (item != 'categories' && this.form.value[item] && item != 'age_restricted') {
            this.filterValues += `&${item}={${this.form.value[item]}}`
          }
        }
        let obj = {};
        for (let i = 0; i < this.categoryIds.length; i++) {
          obj[i.toString()] = this.categoryIds[i];
        }
        this.filterValues += Object.keys(obj).length != 0 ? `&categories=${JSON.stringify(obj)}` : '';
        this.filterValues += (this.form.value['age_restricted'] === true || this.form.value['age_restricted'] === false) ?`&age_restricted=${this.form.value['age_restricted'] ? 1 : 0}` : '';
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
