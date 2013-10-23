---
layout: post
title: Mapping PagedList with AutoMapper
categories:
- technology
tags:
- automapper
- csharp
- pagedlist
status: publish
type: post
published: true
meta:
  aktt_notify_twitter: 'no'
  _edit_last: '1'
  _syntaxhighlighter_encoded: '1'
---
I'm using an implementation of PagedList based on that [given by Rob Conery](http://wekeroad.com/2007/12/10/aspnet-mvc-pagedlistt/).

I want to convert a paged list of business objects to a paged list of view model objects with [AutoMapper](http://automapper.org/). In order for AutoMapper to work in this case, it needs to know how to convert a paged list.  This can be done with a [custom type converter](https://github.com/AutoMapper/AutoMapper/wiki/Custom-type-converters):

``` csharp
public class PagedListConverter : ITypeConverter<PagedList<Person>, PagedList<PersonViewModel>>
{
   public PagedList<PersonViewModel> Convert(ResolutionContext context)
   {
      var models = (PagedList<Person>)context.SourceValue;
      var viewModels = models.Select(p => Mapper.Map<Person, PersonViewModel>(p)).ToList();
      return new PagedList<PersonViewModel>(viewModels, models.PageIndex, models.PageSize);
   }
}
```

To create the mappings:

``` csharp
Mapper.CreateMap<Person, PersonViewModel>();
Mapper
   .CreateMap<PagedList<Person>, PagedList<PersonViewModel>>()
   .ConvertUsing<PagedListConverter>();
```

And to perform the mappings with some sample data:

``` csharp
var persons = new List<Person> {
   new Person { Name = "Luke Skywalker", Phone = "2947-3479" },
   new Person { Name = "Darth Vader", Phone = "2038-3424" }
};
var inputList = new PagedList<Person>(persons, 0, 2);
var outputList = Mapper.Map<PagedList<Person>, PagedList<PersonViewModel>>(inputList);
```
