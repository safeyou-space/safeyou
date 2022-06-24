import {Component, EventEmitter, Input, OnInit, Output, ViewChild} from '@angular/core';
import { FormControl, FormGroup, Validators} from "@angular/forms";
import {AngularMultiSelect} from "angular2-multiselect-dropdown";
import {HelperService} from "../../../../../shared/helper.service";
import * as customBuild from '../../../../../shared/ckCustomBuild/build/ckeditor.js';


@Component({
  selector: 'app-language-edit-create',
  templateUrl: './language-edit-create.component.html',
  styleUrls: ['./language-edit-create.component.css']
})
export class LanguageEditCreateComponent implements OnInit {
  @Output() myEvent = new EventEmitter();
  @ViewChild('dropdownRef',{static:false}) dropdownRef:any = AngularMultiSelect;
  @ViewChild('dropdownRef2',{static:false}) dropdownRef2:any = AngularMultiSelect;
  itemList: any;
  selectedItems: any;
  settings = {};
  itemListCountry: any;
  selectedItemsCountry: any;
  settingsCountry = {};
  form = new FormGroup({
    language: new FormControl('', Validators.required),
    country: new FormControl('', Validators.required),
    sms: new FormControl('', Validators.required),
    police: new FormControl('', Validators.required),
    about: new FormControl('', Validators.required),
    secret: new FormControl('', Validators.required),
    suggestion: new FormControl('', Validators.required),
  });

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


  constructor(public helperService: HelperService) { }
  ngOnInit(): void {
    this.itemList = [
      {"id": 1, "itemName": "Հայերեն"},
      {"id": 2, "itemName": "English"},
      {"id": 3, "itemName": "ქართული"},
      {"id": 4, "itemName": "العربية"},
    ];

    this.selectedItems = [];

    this.itemListCountry = [
      {"id":1,"itemName":"Հայաստան"},
      {"id":2,"itemName":"Վրաստան"},
      {"id":3,"itemName":"Ռուսաստան"},
    ];

    this.selectedItemsCountry = [];


    setTimeout(() => {
      this.settings = {
        text: this.helperService.translation?.select_language,
        selectAllText: 'Select All',
        unSelectAllText: 'UnSelect All',
        enableSearchFilter: true,
        classes: "myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false,
      };
    },0);

   setTimeout(() => {
     this.settingsCountry = {
       text: this.helperService.translation?.select_country,
       selectAllText: 'Select All',
       unSelectAllText: 'UnSelect All',
       enableSearchFilter: true,
       classes: "myclass custom-class",
       showCheckbox: true,
       singleSelection: true,
       autoPosition: false,
     };
   },0)
  }

  onSubmit() {
  }

  onItemSelect(item:any){
    this.dropdownRef.closeDropdown()

  }
  OnItemDeSelect(item:any){
    this.dropdownRef.closeDropdown()
  }

  onItemSelectCountry(item:any){
    this.dropdownRef2.closeDropdown()

  }
  OnItemDeSelectCountry(item:any){
    this.dropdownRef2.closeDropdown()
  }

  close(){
    this.myEvent.emit('close')
  }

}
