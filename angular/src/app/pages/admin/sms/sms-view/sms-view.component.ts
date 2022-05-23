import {
  Component,
  DoCheck,
  EventEmitter,
  Input,
  OnChanges,
  OnDestroy,
  OnInit,
  Output,
  SimpleChanges
} from '@angular/core';
import {HelperService} from "../../../../shared/helper.service";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../../shared/request.service";
import {environment} from "../../../../../environments/environment.prod";
import {FormBuilder, Validators} from "@angular/forms";

@Component({
  selector: 'app-sms-view',
  templateUrl: './sms-view.component.html',
  styleUrls: ['./sms-view.component.css']
})
export class SmsViewComponent implements OnInit, OnChanges, OnDestroy {

  @Input() data;
  @Output() myEvent = new EventEmitter();
  isShowData;
  language: any;
  country: any;
  url: string = '';
  form = this.fb.group({
    password: ['', Validators.required]
  });
  id: any;
  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public fb: FormBuilder,
              public requestService: RequestService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.sms.get}`;
  }

  ngOnInit(): void {
    this.isShowData = localStorage.getItem('is_super_admin') == 'true' ? true : false;
  }

  getItemData (id, params = '') {
      this.requestService.getData(`${this.url}/${id}${params}`).subscribe((item) => {
        this.isShowData = true;
        this.data = item;
        // console.log(item);
      });
  }

  ngOnChanges(changes: SimpleChanges): void {
    this.id = changes.data.currentValue?.id;
    if (changes.data.currentValue && this.isShowData) {
      this.getItemData(changes.data.currentValue['id']);
    }
  }

  ngOnDestroy(): void {
  }

  close(){
    this.myEvent.emit('close');
  }
  onSubmit() {
    if (this.form.valid) {
      this.getItemData(this.id, `?securePassword=${this.form.value.password}`);
    }
  }
}
