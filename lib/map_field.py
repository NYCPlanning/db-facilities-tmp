from dataflows.helpers.resource_matcher import ResourceMatcher

def apply_operation(operation, rows, name):
    for row in rows:
        try: 
            row[name] = operation(row[name])
            yield row
        except: 
            yield row

def map_field(name, operation, resources=None):
    
    def func(package):
        matcher = ResourceMatcher(resources, package.pkg)
        
        yield package.pkg
        for res in package:
            if matcher.match(res.res.name):
                yield apply_operation(operation, res, name)
            else:
                yield res

    return func
