import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReportsComponent} from "./reports.component";
import {ReportsRoutingModule} from "./reports-routing.module";
import {SharedModule} from "../../../components/shared.module";
import {TabsModule} from "ngx-bootstrap/tabs";
import { ReportViewComponent } from './report-view/report-view.component';
import {TooltipModule} from "ngx-bootstrap/tooltip";
import {ModalModule} from "ngx-bootstrap/modal";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {PaginationModule} from "ngx-bootstrap/pagination";
import { ReportCategoryComponent } from './report-category/report-category.component';


@NgModule({
  declarations: [ReportsComponent, ReportViewComponent, ReportCategoryComponent],
  imports: [
    CommonModule,
    SharedModule,
    ReportsRoutingModule,
    TabsModule.forRoot(),
    TooltipModule.forRoot(),
    ModalModule.forRoot(),
    PaginationModule,
    FormsModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class ReportsModule { }
