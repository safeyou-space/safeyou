import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CategoryConsultantsComponent } from './category-consultants.component';

describe('CategoryConsultantsComponent', () => {
  let component: CategoryConsultantsComponent;
  let fixture: ComponentFixture<CategoryConsultantsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CategoryConsultantsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CategoryConsultantsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
