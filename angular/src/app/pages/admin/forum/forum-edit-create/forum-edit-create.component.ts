import {Component, EventEmitter, Input, OnInit, Output, ViewChild} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { HelperService } from "../../../../shared/helper.service";
import { apiUrl, environment } from "../../../../../environments/environment.prod";
import { RequestService } from "../../../../shared/request.service";
import { ActivatedRoute } from "@angular/router";
import { ForumComponent } from "../forum.component";
import { ToastrService } from "ngx-toastr";
import * as customBuild from '../../../../shared/ckCustomBuild/build/ckeditor.js';
import {ChangeEvent} from "@ckeditor/ckeditor5-angular";

@Component({
  selector: 'app-forum-edit-create',
  templateUrl: './forum-edit-create.component.html',
  styleUrls: ['./forum-edit-create.component.css']
})
export class ForumEditCreateComponent implements OnInit {
  @ViewChild("myEditorDescription", { static: false }) myEditorDescription: any;
  @ViewChild("myEditorShortDescription", { static: false }) myEditorShortDescription: any;

  url: any;
  language: any;
  country: any;
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
      ],
      previewsInData: true
    },
    language: 'en',
  };

  itemList: any;
  settings = {};
  languageCollapse = {};
  static instance: ForumEditCreateComponent;
  languageTranslations: any;
  objectKeys = Object.keys;
  imageValue: any;
  editImagePath: any;
  imagePath: any;
  image: any;
  file: any;
  type: boolean = false;
  @Output() getEvent = new EventEmitter();
  id: any;
  form: any = FormGroup;
  copyOrEdit: any;
  wordCount: any= {};
  letterCount: any= {};


  constructor(public requestService: RequestService,
              public activateRoute: ActivatedRoute,
              public helperService: HelperService,
              public fb: FormBuilder,
              private toastr: ToastrService) {
    ForumEditCreateComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.forum.get}`;
    this.getCategoryList();

    this.formGet();

    setTimeout(() => {
      this.settings = {
        text: this.helperService.translation?.select_category,
        selectAllText: this.helperService.translation?.select_all,
        unSelectAllText: this.helperService.translation?.unselect_all,
        enableSearchFilter: true,
        classes: "myclass custom-class",
        showCheckbox: true,
        singleSelection: false,
        autoPosition: false,
      };
    }, 0);
  }

  getCategoryList () {
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.forum.getAllCategoryList}`).subscribe((res: any) => {
      if (!res['message']) {
        this.itemList = [];
        for (let i in res) {
          this.itemList.push(
            {"id": +i,"itemName":res[i]}
          );
        }

      }
    });
  }

  onChangeEditor( { editor }: ChangeEvent, lang, type ) {
    if (editor != undefined) {
      this.wordCount[lang + type] = this.helperService._getWords(editor.model.document.getRoot());
      this.letterCount[lang + type] = this.helperService._getCharacters(editor.model.document.getRoot());
    }
  }

  formGet() {
    this.form = this.fb.group({
      image: ['', Validators.required],
      categories: ['', Validators.required],
      age_restricted: [false],
      translations: this.fb.group({}),
    });
    this.form.reset();
  }



  async convertRelativeUriToFile (filePath, fileName, mimeType, cb) {
    mimeType = mimeType || `image/${filePath.split('.')[filePath.split('.').length - 1]}`;
    const imageUrl = await fetch(filePath, {method: 'GET', cache: 'no-cache'});
    const buffer = await imageUrl.arrayBuffer();
    cb(new File([buffer], fileName, {type:mimeType}));
  }

  getDataById(id, type?) {
    this.id = id;
    this.copyOrEdit = type;
    this.requestService.getData(this.url + '/' + id).subscribe((res: any) => {
      if (this.copyOrEdit == 'edit') {
        this.editImagePath = res.image.url;
        this.form.controls.image.clearValidators();
        this.form.controls.image.updateValueAndValidity();
        this.imageValue = undefined;
        this.type = true;
      }
      this.getLanguageList(res['translations']);
      let arr = [] as any;
      if (res['image'] && type == 'copy') {
        const img = apiUrl + res['image'].url;
        this.convertRelativeUriToFile(img, res['image'].name,null, (file) => {
          this.form.controls.image.clearValidators();
          this.form.controls.image.updateValueAndValidity();
          this.onChange(file);
        })
      }

      for (let i = 0; i < res.categories.length; i++) {
        arr.push({
          id: res.categories[i].id,
          itemName: res.categories[i].translation
        })
      }
      this.form.patchValue({
        categories: arr,
        age_restricted: res.age_restricted
      })

    })
  }

  getLanguageList(value?) {
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.getLanguageList}`).subscribe((item: any) => {
      let data = item;
      this.languageTranslations = item;
      let translations = this.form.get('translations') as FormGroup;
      for (let i = 0; i < data.length; i++) {
        let a = {
          description: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].description : '',
            data[i]['code'] !== 'ps' ? Validators.compose([Validators.required, Validators.minLength(3)]) : ''],
          short_description: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].short_description : '',
            data[i]['code'] !== 'ps' ? Validators.compose([Validators.required, Validators.minLength(3)]) : ''],
          title: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].title : '',
            data[i]['code'] !== 'ps' ? Validators.compose([Validators.required, Validators.minLength(3)]) : ''],
        };
        translations.setControl(data[i]['code'], this.fb.group(a));
        ForumComponent.instance.openAddOrCreate = true;
      }
    }, (error) => {

    })
  }

  onSubmit(status?) {
    if (this.form.valid) {
      let url = this.copyOrEdit == 'edit' ? this.url + '/' + this.id : this.url;
      this.form.value.age_restricted = this.form.value.age_restricted ? '1' : '0';
      let data = new FormData();
      for (let key in this.form.value) {
        if (key == 'image') {
          if (this.file) {
            data.append(key, this.file);
          }
        } else if (key == 'translations') {
          for (let item in this.form.value['translations']) {
            for (let res in this.form.value['translations'][item]) {
              if (this.form.value['translations'][item][res]) {
                data.append(`translations[${item}][${res}]`, this.form.value['translations'][item][res].replaceAll('&nbsp;', ' '));
              }
            }
          }
        } else if (key == 'categories') {
          for (let item in this.form.value['categories']) {
            data.append(`categories[${[item]}]`, this.form.value['categories'][item].id);
          }
        } else {
          data.append(key, this.form.value[key]);
        }
      }
      data.append('status', status);

      if (this.copyOrEdit == 'edit') {
        data.append('_method', 'PUT')
      }


      this.requestService.createData(url, data).subscribe((res) => {
        this.close();
        ForumComponent.instance.openAddOrCreate = false;
        if (ForumComponent.instance.forumsType == 2) {
          ForumComponent.instance.getMyForums(ForumComponent.instance.urlConstructor());
        } else {
          ForumComponent.instance.sortingValue = {'created_at': 'DESC'}
          ForumComponent.instance.getData(ForumComponent.instance.urlConstructor('all'));
        }
      })
    } else {
      let showError = '';
      for (let i in this.form.controls) {
        if (this.form.controls[i].status == "INVALID") {
          if (i != 'translations') {
            showError += `${this.helperService.translation[i] + ' ' + this.helperService.translation?.is_required} \n`
          }
        }
      }

      for (let j in this.form.controls.translations.controls) {
        if (this.form.controls.translations.controls[j].status == "INVALID") {
          for (let k in this.form.controls.translations.controls[j].controls) {
            if (this.form.controls.translations.controls[j].controls[k].status == "INVALID") {
              showError += `${this.helperService.translation[k] + ` ${this.helperService.translation[j]}` + ' ' + this.helperService.translation?.is_required} \n`
            }
          }
        }
      }
      this.toastr.error(showError);
      this.form.markAllAsTouched();
    }
  }

  closeDropdown(dropdownRef) {
  }

  close() {
    this.wordCount = {};
    this.letterCount = {};
    this.copyOrEdit = undefined;
    this.id = undefined;
    this.editImagePath = undefined;
    this.imageValue = undefined;
    this.file = undefined;
    this.type = false;
    this.form.reset();
  }

  onChange(e) {
    this.file = e.target ? e.target.files[0] : e;
    if (this.file) {
      const fileName = this.file.name;
      if (/\.(jpe?g|png|bmp)$/i.test(fileName)) {
        const filesize = this.file.size;
        if (filesize > 15728640) {
          this.form.controls.image.setErrors({size: 'error'});
        } else {
          this.type= true;
          let reader = new FileReader();
          reader.readAsDataURL(this.file);
          reader.onload = () => {
            this.imageValue = reader.result;
          };
          this.image = this.file;
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


  log(event: boolean, index) {
    this.languageCollapse[index] = event;
  }

}
