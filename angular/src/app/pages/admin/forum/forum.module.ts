import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {CKEditorModule} from "@ckeditor/ckeditor5-angular";
import {SharedModule} from "../../../components/shared.module";
import {ForumComponent} from "./forum.component";
import {ForumRoutingModule} from "./forum-routing.module";
import { ForumViewComponent } from './forum-view/forum-view.component';
import { ForumEditCreateComponent } from './forum-edit-create/forum-edit-create.component';
import { ForumChatComponent } from './forum-chat/forum-chat.component';
import {TabsModule} from "ngx-bootstrap/tabs";
import {BsDropdownModule} from "ngx-bootstrap/dropdown";
import {ModalModule} from "ngx-bootstrap/modal";
import {TooltipModule} from "ngx-bootstrap/tooltip";
import { AccordionModule } from 'ngx-bootstrap/accordion';
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {PaginationModule} from "ngx-bootstrap/pagination";
import { ForumCategoryComponent } from './forum-category/forum-category.component';
import { RecivedForumDirective } from 'src/app/shared/Directives/recived-forum.directive';



@NgModule({
  declarations: [ForumComponent, ForumViewComponent, ForumEditCreateComponent, ForumChatComponent, ForumCategoryComponent, RecivedForumDirective],
  imports: [
    CommonModule,
    ForumRoutingModule,
    CKEditorModule,
    SharedModule,
    TabsModule.forRoot(),
    BsDropdownModule.forRoot(),
    ModalModule.forRoot(),
    TooltipModule.forRoot(),
    AccordionModule.forRoot(),
    AngularMultiSelectModule,
    FormsModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    PaginationModule,
  ]
})
export class ForumModule { }
