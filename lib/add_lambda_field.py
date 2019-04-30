from dataflows.helpers.resource_matcher import ResourceMatcher

def rename_in_row(rows):
    for row in rows:
        row = dict((k.lower().replace(' ', '_'), v) for k, v in row.items())
        yield row

def add_lambda_field(name, new_name, resources=None):
    
    def func(package):
        matcher = ResourceMatcher(resources, package.pkg)
        for resource in package.pkg.descriptor['resources']:
            if matcher.match(resource['name']):
                resource['schema']['fields'].append()

        yield package.pkg
        for res in package:
            if matcher.match(res.res.name):
                yield rename_in_row(res)
            else:
                yield res
    return func