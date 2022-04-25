import {Component, Input, OnInit, ViewChild} from '@angular/core';
import { FormControl, FormGroup, Validators} from "@angular/forms";
import {AngularMultiSelect} from "angular2-multiselect-dropdown";
import {HelperService} from "../../../../../shared/helper.service";
import * as customBuild from '../../../../../shared/ckCustomBuild/build/ckeditor.js';


@Component({
  selector: 'app-organizations-staff-edit-create',
  templateUrl: './organizations-staff-edit-create.component.html',
  styleUrls: ['./organizations-staff-edit-create.component.css']
})
export class OrganizationsStaffEditCreateComponent implements OnInit {
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
  @ViewChild('dropdownRef',{static:false}) dropdownRef:any = AngularMultiSelect;
  @ViewChild('dropdownRefCountry',{static:false}) dropdownRefCountry:any = AngularMultiSelect;
  files: any[] = [];
  itemList: any;
  itemListCountry: any;
  selectedItems: any;
  selectedItemsCountry: any;
  settings = {};
  settingsCountry = {};
  form = new FormGroup({
    file: new FormControl('', Validators.required),
    name: new FormControl('', Validators.required),
    lastname: new FormControl('', Validators.required),
    profession: new FormControl('', Validators.required),
    country: new FormControl('', Validators.required),
    city: new FormControl('', Validators.required),
    address: new FormControl('', Validators.required),
    description: new FormControl('', Validators.required),
    email: new FormControl('', Validators.required),
    facebook: new FormControl('', Validators.required),
    instagram: new FormControl('', Validators.required),
  });

  constructor(public helperService: HelperService) { }

  ngOnInit(): void {

    this.itemList = [
      {"id":1,"itemName":"Հոգեբան"},
      {"id":2,"itemName":"Սոցիալական աշխատող"},
      {"id":3,"itemName":"Իրավաբան"},
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
        text:this.helperService.translation?.select_profession,
        selectAllText:'Select All',
        unSelectAllText:'UnSelect All',
        enableSearchFilter: true,
        classes:"myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false
      };
      this.settingsCountry = {
        text:this.helperService.translation?.select_country,
        selectAllText:'Select All',
        unSelectAllText:'UnSelect All',
        enableSearchFilter: true,
        classes:"myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false
      };
    },0);
  }

  onChange(files) {
  }

  onItemSelect(item:any){
    this.dropdownRef.closeDropdown()

  }
  OnItemDeSelect(item:any){
    this.dropdownRef.closeDropdown()
  }

  onItemSelectCountry(item:any){
    this.dropdownRefCountry.closeDropdown()

  }
  OnItemDeSelectCountry(item:any){
    this.dropdownRefCountry.closeDropdown()
  }

  onSubmit() {
  }

}
