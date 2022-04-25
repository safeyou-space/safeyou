import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { OrganizationsRoutingModule } from './organizations-routing.module';
import { OrganizationsComponent } from './organizations.component';
import {SharedModule} from "../../../../components/shared.module";
import {TabsModule} from "ngx-bootstrap/tabs";
import {CKEditorModule} from "@ckeditor/ckeditor5-angular";
import { OrganizationsViewComponent } from './organizations-view/organizations-view.component';
import {BsDropdownModule} from "ngx-bootstrap/dropdown";
import {ModalModule} from "ngx-bootstrap/modal";
import { OrganizationsProfessionComponent } from './organizations-profession/organizations-profession.component';
import {TooltipModule} from "ngx-bootstrap/tooltip";
import {AccordionModule} from "ngx-bootstrap/accordion";
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import { OrganizationsStaffEditCreateComponent } from './organizations-staff-edit-create/organizations-staff-edit-create.component';
import { OrganizationsStaffViewComponent } from './organizations-staff-view/organizations-staff-view.component';
import {PaginationModule} from "ngx-bootstrap/pagination";


@NgModule({
  declarations: [
    OrganizationsComponent,
    OrganizationsViewComponent,
    OrganizationsProfessionComponent,
    OrganizationsStaffEditCreateComponent,
    OrganizationsStaffViewComponent,
  ],
  imports: [
    CommonModule,
    OrganizationsRoutingModule,
    SharedModule,
    TabsModule.forRoot(),
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
export class OrganizationsModule { }
