import {Component, OnInit, ViewChild} from '@angular/core';
import {animate, state, style, transition, trigger} from "@angular/animations";
import {HelperService} from "../../../../shared/helper.service";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../../shared/request.service";
import {environment} from "../../../../../environments/environment.prod";
import {ModalDirective} from "ngx-bootstrap/modal";
import {FormBuilder, Validators} from "@angular/forms";

@Component({
  selector: 'app-language',
  templateUrl: './language.component.html',
  styleUrls: ['./language.component.css'],
  animations: [
    trigger('openClose', [
      state('open', style({
        opacity: '1',
        visibility: 'visible',
        position: 'absolute',
        zIndex: 10,
        width: '100%'
      })),
      state('closed', style({
        opacity: '0',
        visibility: 'hidden',
        position: 'absolute',
        zIndex: 5,
        width: '100%'
      })),
      transition('open <=> closed', [
        animate('0.8s ease-in-out')
      ]),
    ]),
  ]
})
export class LanguageComponent implements OnInit {
  @ViewChild('autoShownModal', { static: false }) autoShownModal: any = ModalDirective;
  isOpen = true;
  language: any;
  country: any;
  data: any;
  url: string = '';
  viewData: any;
  isModalShown = false;
  form = this.fb.group({
    status: [{value: '', disabled: true}],
    title: ['', Validators.required],
    code: [''],
    image: ['']
  });
  id: any;
  imagePath: any;
  image: any;
  imageValue: any;
  editImagePath: any;
  file: any;
  type:boolean = false;
  allPageData: any;


  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public fb: FormBuilder,
              public requestService: RequestService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.languages.getApplication}`;
  }

  ngOnInit(): void {
    this.getData(this.url);
  }

  getData(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.data = items['data'];
      this.allPageData = items;
    })
  }

  close () {
    this.isOpen = true;
  }

  showModal(value): void {
    this.id = value.id
    this.form.patchValue({
      status: value.status,
      title: value.title,
      code: value.code
    });
    this.type = true;
    this.editImagePath = value.image.url;
    this.isModalShown = true;
  }

  hideModal(): void {
    this.autoShownModal.hide();
    this.imagePath = undefined;
    this.image = undefined;
    this.imageValue = undefined;
    this.editImagePath = undefined;
    this.file = undefined;
    this.form.reset()
  }

  onHidden(): void {
    this.isModalShown = false;
  }
  save() {
    let val = new FormData();
    for (let i in this.form.value) {
      if (i != 'image') {
        val.append(i, this.form.value[i]);
      }else {
        if (this.file) {
          val.append('image', this.file)
        }
      }
    }
    if (this.form.valid) {
      val.append('_method', 'PUT');
      val.append('status', '1');
      this.requestService.createData(`${this.url}/${this.id}`, val).subscribe(() => {
        this.getData(this.url);
        this.hideModal();
      })
    }
  }

  onChange(e) {
    if (e.target.files[0]) {
      this.file = e.target.files[0];
      const fileName = e.target.files[0].name;
      if (/\.(jpe?g|png|bmp)$/i.test(fileName)) {
        const filesize = e.target.files[0].size;
        if (filesize > 15728640) {
          this.form.controls.image.setErrors({size: 'error'});
        } else {
          this.type= true;
          let reader = new FileReader();
          reader.readAsDataURL(e.target.files[0]);
          reader.onload = () => {
            this.imageValue = reader.result;
          };
          this.image = e.target.files[0];
        }
      } else {
        this.form.controls.image.setErrors({type: 'error'});
      }
    } else {
      this.editImagePath ? this.type = true : this.type = false;
      this.file = undefined;
      this.imageValue = undefined;
      this.form.controls.image.setErrors(null);
    }
  }

  pageChanged(event) {
    this.allPageData.current_page = event.page;
    this.getData(`${this.url}?page=${event.page}`);
  }

}
