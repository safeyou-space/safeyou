import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {DashboardRoutingModule} from "./dashboard-routing.module";
import {DashboardComponent} from "./dashboard.component";
import {CKEditorModule} from "@ckeditor/ckeditor5-angular";
import {SharedModule} from "../../../components/shared.module";

@NgModule({
  declarations: [DashboardComponent],
  imports: [
    CommonModule,
    DashboardRoutingModule,
    CKEditorModule,
    SharedModule,
  ]
})
export class DashboardModule { }
