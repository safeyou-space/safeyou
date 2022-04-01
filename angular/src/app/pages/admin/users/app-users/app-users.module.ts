import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SharedModule } from 'src/app/components/shared.module';
import { BsDropdownModule } from 'ngx-bootstrap/dropdown';
import {AppUsersRoutingModule} from "./app-users-routing.module";
import {AppUsersComponent} from "./app-users.component";
import { AppUserViewComponent } from './app-user-view/app-user-view.component';
import { AppUserEditCreateComponent } from './app-user-edit-create/app-user-edit-create.component';
import {ModalModule} from "ngx-bootstrap/modal";
import {TooltipModule} from "ngx-bootstrap/tooltip";
import {AccordionModule} from "ngx-bootstrap/accordion";
import {CKEditorModule} from "@ckeditor/ckeditor5-angular";
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {PaginationModule} from "ngx-bootstrap/pagination";
import { AppUsersFilterComponent } from './app-users-filter/app-users-filter.component';


@NgModule({
  declarations: [
    AppUsersComponent,
    AppUserViewComponent,
    AppUserEditCreateComponent,
    AppUsersFilterComponent
  ],
  imports: [
    CommonModule,
    AppUsersRoutingModule,
    SharedModule,
    BsDropdownModule.forRoot(),
    ModalModule.forRoot(),
    TooltipModule.forRoot(),
    AccordionModule.forRoot(),
    CKEditorModule,
    PaginationModule,
    AngularMultiSelectModule,
    FormsModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class AppUsersModule { }
