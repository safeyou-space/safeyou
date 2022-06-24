import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {CKEditorModule} from "@ckeditor/ckeditor5-angular";
import {LanguageComponent} from "./language.component";
import {LanguageRoutingModule} from "./language-routing.module";
import { LanguageEditCreateComponent } from './language-edit-create/language-edit-create.component';
import {TabsModule} from "ngx-bootstrap/tabs";
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {SharedModule} from "../../../../components/shared.module";
import {ModalModule} from "ngx-bootstrap/modal";
import {PaginationModule} from "ngx-bootstrap/pagination";

@NgModule({
  declarations: [LanguageComponent, LanguageEditCreateComponent],
  imports: [
    CommonModule,
    LanguageRoutingModule,
    CKEditorModule,
    SharedModule,
    TabsModule.forRoot(),
    AngularMultiSelectModule,
    ModalModule.forRoot(),
    PaginationModule,
    FormsModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class LanguageModule { }
