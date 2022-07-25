import {Component, Input, OnInit} from '@angular/core';
import {HelperService} from "../../../../shared/helper.service";
import {animate, state, style, transition, trigger} from "@angular/animations";
import {FormArray, FormBuilder, Validators} from "@angular/forms";
import {RequestService} from "../../../../shared/request.service";
import {environment} from "../../../../../environments/environment.prod";
import {ActivatedRoute} from "@angular/router";
import {ToastrService} from "ngx-toastr";
import * as customBuild from '../../../../shared/ckCustomBuild/build/ckeditor.js';
import {ChangeEvent} from "@ckeditor/ckeditor5-angular";
import {forkJoin} from "rxjs";


@Component({
  selector: 'app-terms-and-conditions',
  templateUrl: './terms-and-conditions.component.html',
  styleUrls: ['./terms-and-conditions.component.css'],
  animations: [
    trigger('openClose', [
      state('closedIf', style({
        position: 'absolute',
        opacity: 0,
        visibility: 'hidden',
        height: 0,
        overflow: 'hidden'
      })),

      state('openIf', style({
      })),

      transition('openIf <=> closedIf', [
        animate('0.5s linear')
      ]),
    ]),
  ]
})
export class TermsAndConditionsComponent implements OnInit {
  show = true;
  backPage = true;
  public Editor = customBuild;
  @Input() config = {

    toolbar: ['heading', 'bold', 'italic', 'link', 'outdent','blockQuote','insertTable', 'indent', 'numberedList', 'bulletedList', 'imageUpload', 'undo', 'redo','mediaEmbed' ],
    image: {
      styles: [
        'alignLeft', 'alignCenter', 'alignRight'
      ],
      resizeOptions: [
        {
          name: 'resizeImage:original',
          label: 'Original',
          value: null
        },
        {
          name: 'resizeImage:50',
          label: '25%',
          value: '25'
        },
        {
          name: 'resizeImage:50',
          label: '50%',
          value: '50'
        },
        {
          name: 'resizeImage:75',
          label: '75%',
          value: '75'
        }
      ],
      toolbar: [
        'imageStyle:alignLeft', 'imageStyle:alignCenter', 'imageStyle:alignRight',
        '|',
        'ImageResize',
        '|',
        'imageTextAlternative'
      ]
    },
    mediaEmbed: {
      toolbar: [
        'imageStyle:alignLeft', 'imageStyle:alignCenter', 'imageStyle:alignRight',
        '|',
        'ImageResize',
        '|',
        'imageTextAlternative'
      ]
    },
    language: 'en',
  };
  url: any;
  id: any;
  form = this.fb.group({
    title: ['', Validators.required],
    content: this.fb.array([]),
  });
  objectKeys = Object.keys;
  get translationsForm() {
    return this.form.get('content') as FormArray;
  }
  languageTranslations: any;
  language: any;
  country: any;
  data: any;
  wordCount: any= {};
  letterCount: any= {};
  newContent: any;
  newContentId: any;

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              private requestService: RequestService,
              private fb: FormBuilder, private toastr: ToastrService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.content.get}`;
    this.getData(this.url + '?title=terms_conditions');
  }

  getData(url) {
    forkJoin([this.requestService.getData(`${this.url}?title=terms_conditions`), this.requestService.getData(`${this.url}?title=terms_conditions-18`)]).subscribe((result: any) => {
      this.data = result[0]['translations'];
      this.newContent = result[1]['translations'];
      this.newContentId = result[1]['id'];
      this.id = result[0]['id'];
      this.form.patchValue( {
        title: 'terms_conditions'
      });
      let data = result[0];
      this.getLanguageList(data['translations']);
    })
    // this.requestService.getData(url).subscribe((items) => {
      // this.data = items['translations'];
      // let data = items;
      // this.id = items['id'];
      // this.form.patchValue( {
      //   title: 'terms_conditions'
      // });


    // })
  }

  onChangeEditor( { editor }: ChangeEvent, lang) {
    if (editor != undefined) {
      this.wordCount[lang] = this.helperService._getWords(editor.model.document.getRoot());
      this.letterCount[lang] = this.helperService._getCharacters(editor.model.document.getRoot());
    }
  }

  getLanguageList (value?) {
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.getLanguageList}`).subscribe((item: any) => {
      let data = item;
      this.languageTranslations = item;

      while (this.translationsForm.length) {
        this.translationsForm.removeAt(0);
      }
      for (let i = 0; i < data.length; i++) {
        let a = {};
        a[data[i]['code']] = [value ? value[i]['content'] : '', Validators.required];
        a[data[i]['code'] + '-18'] = [this.newContent ? this.newContent[i]['content'] : '', Validators.required];
        this.translationsForm.push(this.fb.group(a));
      }

    }, (error) => {

    })
  }

  onSubmit(form, status) {
    if (this.form.valid) {
      let newData = {};
      let newContent = {}
      for (let i in form) {
        if (i == 'content') {
          let object = {};
          let newContentObject = {}
          for (let index = 0; index < form['content'].length; index++) {
            object[Object.keys(form['content'][index])[0]]  = Object.values(form['content'][index])[0];
            newContentObject[Object.keys(form['content'][index])[0]]  = Object.values(form['content'][index])[1];
          }
          newData['content'] = object;
          newData['status'] = status;
          newContent['status'] = status;
          newContent['content'] = newContentObject;
        } else {
          newData[i] = form[i];
          newContent['title'] = 'terms_conditions-18';
        }
      }

      forkJoin([this.requestService.updateData(this.url, newData, this.id),this.requestService.updateData(this.url, newContent, this.newContentId)]).subscribe(() => {
        this.getData(this.url + '?title=terms_conditions');
        this.show = true;
      })

      // this.requestService.updateData(this.url, newData, this.id).subscribe((res) => {
      //   this.getData(this.url + '?title=terms_conditions');
      //   this.show = true;
      // });
    } else {
      let showError = '';
      for (let i in this.form.controls) {
        if (this.form.controls[i].status == "INVALID") {
          showError += `${this.helperService.translation[i] + ' ' + this.helperService.translation?.is_required} `
        }
      }
      this.toastr.error(showError);
      this.form.markAllAsTouched();
    }
  }

  editBlock() {
    this.show = false;
    this.backPage = true;
  }

  backBlock() {
    this.wordCount = {};
    this.letterCount = {};
    this.backPage = false;
    this.show = true;
  }

}
